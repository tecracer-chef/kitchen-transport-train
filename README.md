# kitchen-transport-train

## Summary

Kitchen transport to use any Train backend.

As Train OS Transports were inspired from Kitchen, they provide an almost identical API. This transport is an adapter to use Test Kitchen with all OS-style Train transports.

In contrast to normal Kitchen drivers, this does not support the `kitchen login` command as Train is inherently non-interactive. An error will be displayed if you try to use this command.

## Examples

Legacy configurations for easy SSH/WinRM connections are supported. This transport will automaticially detect Unix (`ssh` backend) and Windows (`winrm` backend) systems.

```yaml
---
transport:
  name: train
  backend: ssh # optional
  ssh_key: ~/.ssh/testkitchen
```

```yaml
---
transport:
  name: train
  backend: winrm # optional
```

Train-oriented configuration can optionally specify the `backend` transport and then add the transport-specific configuration values:

```yaml
---
transport:
  name: train
  backend: ssh

  # Use the selected Train transport options here 1:1
  key_files: '...'
  compression: true
  ...
```

## Link to Train transport options

Options `user`, `host` and `password` (for kitchen-ec2 and Windows instances) are set automatically.

- [AWS Session Manager Transport](https://github.com/tecracer-chef/train-awsssm/blob/master/lib/train-awsssm/transport.rb#L8-L14)
- Docker Transport: no additional options
- [Serial/USB Transport](https://github.com/tecracer-chef/train-serial/blob/master/lib/train-serial/transport.rb#L8-L22)
- [SSH Transport](https://github.com/inspec/train/blob/0b9fd4556745d767c9dac2a83d5323e6b7025872/lib/train/transports/ssh.rb#L45-L74)
- [Telnet Transport](https://github.com/tecracer-chef/train-telnet/blob/master/lib/train-telnet/transport.rb#L8-L20)
- [WinRM Transport](https://github.com/inspec/train-winrm/blob/980190e44571787c7b60614257bd6dc2bd8a337d/lib/train-winrm/transport.rb#L52-L76)