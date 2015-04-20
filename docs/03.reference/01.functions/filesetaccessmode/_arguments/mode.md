A three-digit value, in which each digit specifies the file access for individuals and groups:
- The first digit represents the owner.
- The second digit represents a group.
- The third digit represents anyone.

Each digit of this code sets permissions for the appropriate individual or group:
- 4 specifies read permission.
- 2 specifies write permission.
- 1 specifies execute permission.

You use the sums of these numbers to indicate combinations of the permissions:
- 3 specifies write and execute permission.
- 5 specifies read and execute permission.
- 6 indicates read and write permission.
- 7 indicates read, write, and execute permission.

For example, 400 specifies that only the owner can read the file; 004 specifies that anyone can read the file.