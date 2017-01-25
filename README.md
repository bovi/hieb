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

```
_files/
|-- bin
|   `-- new.exe
|-- etc
|   `-- complex.cfg
`-- tmp
    |-- temporary.cfg
    |-- temporary.db
    `-- temporary.sh
```

## Remarks

Hieb is an extreme simple tool to execute commands and upload files using only SSH. It is by no mean a replacement for tools like Puppets, Chef, etc. The intention is to have a tool for one time deployments without complex dependencies. I always had the feeling most tools a to complex for extreme simple machine deployments.

To simplify the command execution you can add the following to your ```/etc/sudoers```:

```
user ALL=(ALL) NOPASSWD: ALL
```

This allows the usage of ```sudo``` without passing a password.
