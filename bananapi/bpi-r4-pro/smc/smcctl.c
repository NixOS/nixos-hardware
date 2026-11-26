/* smcctl -- call /dev/smc from userspace.
 *
 *   smcctl version        PSCI version (harmless smoke test)
 *   smcctl features       PSCI feature set
 *   smcctl reset          PSCI SYSTEM_RESET  (0x84000009) -- hard reboot
 *   smcctl off            PSCI SYSTEM_OFF    (0x84000008)
 *   smcctl raw <fn> [a1..a6...]
 *
 * On success reset/off do not return; if the ioctl comes back, the secure
 * monitor rejected the call and the return registers say why.
 */
#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <unistd.h>

#define SMC_IOC_MAGIC 'S'

struct smc_req {
	uint64_t a0, a1, a2, a3, a4, a5, a6;
	uint64_t r0, r1, r2, r3;
};

#define SMC_IOCTL_CALL _IOWR(SMC_IOC_MAGIC, 1, struct smc_req)

#define PSCI_0_2_FN_PSCI_VERSION  0x84000000ULL
#define PSCI_0_2_FN_PSCI_FEATURES 0x8400000aULL
#define PSCI_0_2_FN_SYSTEM_OFF    0x84000008ULL
#define PSCI_0_2_FN_SYSTEM_RESET  0x84000009ULL

static int call(struct smc_req *r)
{
	int fd = open("/dev/smc", O_RDWR);

	if (fd < 0) {
		fprintf(stderr, "open /dev/smc: %s\n", strerror(errno));
		return 1;
	}
	if (ioctl(fd, SMC_IOCTL_CALL, r) < 0) {
		fprintf(stderr, "ioctl: %s\n", strerror(errno));
		close(fd);
		return 1;
	}
	close(fd);
	return 0;
}

static void show(const char *what, struct smc_req *r)
{
	printf("%-8s fn=%#llx -> x0=%#llx x1=%#llx x2=%#llx x3=%#llx\n",
	       what, (unsigned long long)r->a0,
	       (unsigned long long)r->r0, (unsigned long long)r->r1,
	       (unsigned long long)r->r2, (unsigned long long)r->r3);
}

int main(int argc, char **argv)
{
	struct smc_req r = { 0 };

	if (argc < 2) {
		fprintf(stderr,
			"usage: %s version|features|reset|off|raw <fn> [a1..a6]\n",
			argv[0]);
		return 2;
	}

	if (!strcmp(argv[1], "version")) {
		r.a0 = PSCI_0_2_FN_PSCI_VERSION;
		if (call(&r))
			return 1;
		show("version", &r);
		printf("         PSCI %llu.%llu\n",
		       (unsigned long long)(r.r0 >> 16),
		       (unsigned long long)(r.r0 & 0xffff));
		return 0;
	}

	if (!strcmp(argv[1], "features")) {
		r.a0 = PSCI_0_2_FN_PSCI_FEATURES;
		r.a1 = PSCI_0_2_FN_SYSTEM_RESET;
		if (call(&r))
			return 1;
		show("features", &r);
		printf("         SYSTEM_RESET supported: %s\n",
		       r.r0 == 0 ? "yes" : "no (returns non-zero)");
		return 0;
	}

	if (!strcmp(argv[1], "reset")) {
		r.a0 = PSCI_0_2_FN_SYSTEM_RESET;
		printf("issuing PSCI SYSTEM_RESET (%#llx)...\n",
		       (unsigned long long)r.a0);
		fflush(stdout);
		if (call(&r))
			return 1;
		show("reset", &r);
		printf("RETURNED -- the reset was NOT performed\n");
		return 0;
	}

	if (!strcmp(argv[1], "off")) {
		r.a0 = PSCI_0_2_FN_SYSTEM_OFF;
		printf("issuing PSCI SYSTEM_OFF (%#llx)...\n",
		       (unsigned long long)r.a0);
		fflush(stdout);
		if (call(&r))
			return 1;
		show("off", &r);
		printf("RETURNED -- the power-down was NOT performed\n");
		return 0;
	}

	if (!strcmp(argv[1], "raw")) {
		int i;

		if (argc < 3) {
			fprintf(stderr, "raw needs a function id\n");
			return 2;
		}
		r.a0 = strtoull(argv[2], NULL, 0);
		for (i = 3; i < argc && i < 9; i++)
			((uint64_t *)&r)[i - 3] = strtoull(argv[i], NULL, 0);
		if (call(&r))
			return 1;
		show("raw", &r);
		return 0;
	}

	fprintf(stderr, "unknown command: %s\n", argv[1]);
	return 2;
}
