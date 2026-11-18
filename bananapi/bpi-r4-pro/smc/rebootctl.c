// SPDX-License-Identifier: GPL-2.0
/* rebootctl -- reset or power off the MT7988 via /dev/reboot.
 *
 *   rebootctl reset   PSCI SYSTEM_RESET (does not return on success)
 *   rebootctl off     PSCI SYSTEM_OFF   (does not return on success)
 *
 * Thin wrapper around writing a verb to /dev/reboot.  This device cannot issue
 * an arbitrary SMC; use /dev/smc (diagnostic build) for that.
 */
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char **argv)
{
	const char *verb;
	int fd;

	if (argc != 2 || (strcmp(argv[1], "reset") && strcmp(argv[1], "off"))) {
		fprintf(stderr, "usage: %s reset|off\n", argv[0]);
		return 2;
	}
	verb = argv[1];

	fd = open("/dev/reboot", O_WRONLY);
	if (fd < 0) {
		fprintf(stderr, "open /dev/reboot: %s\n", strerror(errno));
		return 1;
	}
	if (write(fd, verb, strlen(verb)) < 0) {
		fprintf(stderr, "write /dev/reboot: %s\n", strerror(errno));
		return 1;
	}
	/* Only reached if the kernel refused to act on it. */
	fprintf(stderr, "write /dev/reboot: request not carried out\n");
	return 1;
}
