// SPDX-License-Identifier: GPL-2.0
/*
 * dev_smc.c -- /dev/smc: issue secure monitor calls (SMC) from userspace.
 *
 * WHY
 * ---
 * Every question about BL31 on this board ("does PSCI SYSTEM_RESET reach it?",
 * "what does MTK's SIP handler return?") needed a kernel rebuild to answer,
 * because arm_smccc_smc() is kernel-only and CONFIG_STRICT_DEVMEM blocks poking
 * the secure registers from userspace.
 *
 * This exposes exactly one primitive -- issue SMC #0 with a0..a6 -- and hands
 * back x0..x3.  It cannot do anything the secure monitor would not already do
 * for the kernel, so it grants no extra privilege: the EL1->EL3 boundary and
 * BL31's own validation remain the only gate.
 *
 * INTERFACE
 * ---------
 *   struct smc_req {
 *       __u64 a0, a1, a2, a3, a4, a5, a6;  // in:  function id + arguments
 *       __u64 r0, r1, r2, r3;              // out: return registers
 *   };
 *
 *   ioctl(fd, SMC_IOCTL_CALL, &req);
 *
 * An ioctl (not write/read) on purpose: the call is atomic, and for functions
 * like PSCI SYSTEM_RESET the call itself is the side effect -- there is no
 * meaningful "read the result afterwards".
 *
 * USAGE
 *   SMC_IOCTL_CALL with a0 = PSCI_0_2_FN_PSCI_VERSION (0x84000000) is a
 *   harmless smoke test: it returns the PSCI version and proves the conduit.
 *   Only then try PSCI_0_2_FN_SYSTEM_RESET (0x84000009).
 *
 * NOTE: a PSCI reset/off call does not return on success.  If the ioctl comes
 * back, the call was rejected or ignored -- which is the interesting result.
 */

#include <linux/arm-smccc.h>
#include <linux/fs.h>
#include <linux/ioctl.h>
#include <linux/miscdevice.h>
#include <linux/module.h>
#include <linux/uaccess.h>

#define SMC_IOC_MAGIC 'S'

struct smc_req {
	__u64 a0, a1, a2, a3, a4, a5, a6;
	__u64 r0, r1, r2, r3;
};

#define SMC_IOCTL_CALL _IOWR(SMC_IOC_MAGIC, 1, struct smc_req)

static long smc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
	struct smc_req req;
	struct arm_smccc_res res;

	switch (cmd) {
	case SMC_IOCTL_CALL:
		break;
	default:
		return -ENOTTY;
	}

	if (copy_from_user(&req, (void __user *)arg, sizeof(req)))
		return -EFAULT;

	arm_smccc_smc(req.a0, req.a1, req.a2, req.a3,
		      req.a4, req.a5, req.a6, 0, &res);

	req.r0 = res.a0;
	req.r1 = res.a1;
	req.r2 = res.a2;
	req.r3 = res.a3;

	if (copy_to_user((void __user *)arg, &req, sizeof(req)))
		return -EFAULT;

	pr_info("smc: fn=%#llx -> %#llx %#llx %#llx %#llx\n",
		req.a0, req.r0, req.r1, req.r2, req.r3);

	return 0;
}

static const struct file_operations smc_fops = {
	.owner = THIS_MODULE,
	.unlocked_ioctl = smc_ioctl,
};

static struct miscdevice smc_dev = {
	.minor = MISC_DYNAMIC_MINOR,
	.name = "smc",
	.fops = &smc_fops,
	.mode = 0600, /* root only: an SMC can reset or power off the machine */
};

static int __init smc_init(void)
{
	int ret = misc_register(&smc_dev);

	if (ret)
		pr_err("smc: cannot register /dev/smc: %d\n", ret);
	else
		pr_info("smc: /dev/smc ready\n");

	return ret;
}

static void __exit smc_exit(void)
{
	misc_deregister(&smc_dev);
}

module_init(smc_init);
module_exit(smc_exit);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Issue SMC calls to the secure monitor from userspace");
MODULE_AUTHOR("s-nodus");
