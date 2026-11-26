// SPDX-License-Identifier: GPL-2.0
/*
 * dev_reboot -- reset or power off the MT7988 via PSCI, from userspace.
 *
 * Why this exists
 * ---------------
 * PSCI SYSTEM_RESET works on this SoC: mtk_plat_system_reset() in BL31 sets
 * WDT_SWSYSRST_EN before WDT_SWRST, and hardware confirms the board resets and
 * returns.  The kernel's own route to that call is unreliable on this board --
 * the request is sometimes never carried out, leaving a box that needs the
 * cord pulled.  A shutdown unit that issues the call directly, after the
 * filesystems are safely down, avoids that.
 *
 * Why it is not /dev/smc
 * ----------------------
 * This device deliberately cannot express an arbitrary SMC.  It has no
 * function-id argument and takes no parameters: writing "reset" or "off" is
 * the entire interface.  An unrestricted SMC from userspace is a root -> EL3
 * hole, because BL31 dispatches MediaTek's SIP range without validating
 * arguments and those handlers reach eFuses, devapc and secure-boot state.  A
 * power-management device has no business being able to do that.
 *
 *   echo reset > /dev/reboot    # PSCI SYSTEM_RESET, does not return
 *   echo off   > /dev/reboot    # PSCI SYSTEM_OFF,    does not return
 *   rebootctl reset|off         # same thing
 *
 * This only performs the PSCI call.  Everything that makes that safe --
 * unmounting, remounting read-only, sync(2) -- is the caller's responsibility,
 * which is why the shipped unit is ordered after umount.target and
 * final.target.
 *
 * Copyright (C) 2026 the nixos-hardware contributors
 */

#include <linux/arm-smccc.h>
#include <linux/fs.h>
#include <linux/miscdevice.h>
#include <linux/module.h>
#include <linux/uaccess.h>

#include <uapi/linux/psci.h>

#define DEV_REBOOT_NAME "reboot"
#define DEV_REBOOT_MAX  16

static void __noreturn do_psci(u32 fn)
{
	struct arm_smccc_res res;

	pr_emerg("dev_reboot: issuing PSCI %#x\n", fn);
	arm_smccc_smc(fn, 0, 0, 0, 0, 0, 0, 0, &res);

	/*
	 * Returning here means BL31 refused the call.  Panic rather than fall
	 * back to the kernel path: we were asked to power the machine down, and
	 * silently continuing would look like the call had worked.
	 */
	panic("dev_reboot: PSCI %#x returned %#lx (BL31 refused)\n",
	      fn, (unsigned long)res.a0);
}

static ssize_t dev_reboot_write(struct file *f, const char __user *ubuf,
				size_t len, loff_t *off)
{
	char buf[DEV_REBOOT_MAX];
	size_t n;

	if (len == 0 || len >= sizeof(buf))
		return -EINVAL;

	n = len;
	if (copy_from_user(buf, ubuf, n))
		return -EFAULT;
	buf[n] = '\0';

	/* Trim the newline an `echo` leaves behind. */
	while (n > 0 && (buf[n - 1] == '\n' || buf[n - 1] == ' '))
		buf[--n] = '\0';

	if (!strcmp(buf, "reset"))
		do_psci(PSCI_0_2_FN_SYSTEM_RESET);
	if (!strcmp(buf, "off"))
		do_psci(PSCI_0_2_FN_SYSTEM_OFF);

	return -EINVAL;
}

/*
 * Must be called before do_psci(), which frees nobody.  Fill the caller's
 * buffer with a syncfs() and let it decide -- but the only writer we ship is
 * the shutdown unit, which systemd orders correctly.
 */
static const struct file_operations dev_reboot_fops = {
	.owner = THIS_MODULE,
	.write = dev_reboot_write,
	.llseek = noop_llseek,
};

static struct miscdevice dev_reboot_misc = {
	.minor = MISC_DYNAMIC_MINOR,
	.name = DEV_REBOOT_NAME,
	.fops = &dev_reboot_fops,
	/* Root only.  This resets the machine, so it must not be world-writable. */
	.mode = 0600,
};

static int __init dev_reboot_init(void)
{
	int ret = misc_register(&dev_reboot_misc);

	if (ret)
		return ret;

	pr_info("dev_reboot: /dev/%s ready\n", DEV_REBOOT_NAME);
	return 0;
}

static void __exit dev_reboot_exit(void)
{
	misc_deregister(&dev_reboot_misc);
}

module_init(dev_reboot_init);
module_exit(dev_reboot_exit);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("PSCI reset/poweroff for the MT7988");
MODULE_AUTHOR("nixos-hardware contributors");
