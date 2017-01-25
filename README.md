# hieb

Simple deployment tool using SSH and supporting command execution and file upload

## Usage

Call the `hieb` command for one server like this:

```
hieb 192.168.0.1 user password
```

or

```
hieb 192.168.0.1 user ~/.ssh/id_rsa
```

### Command Execution

Hieb is searching in the working directory for `_exe.json`. The content might look like this:

```
{
  "commands": [
    "hostname",
    "ls -lah /tmp"
  ]
}
```

### File Upload

Hieb is searching in the working directory for `_files`. The content of this directory will be uploaded starting from the root directory.
