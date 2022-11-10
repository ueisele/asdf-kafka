<div align="center">

# asdf-kafka [![Build](https://github.com/ueisele/asdf-kafka/actions/workflows/build.yml/badge.svg)](https://github.com/ueisele/asdf-kafka/actions/workflows/build.yml) [![Lint](https://github.com/ueisele/asdf-kafka/actions/workflows/lint.yml/badge.svg)](https://github.com/ueisele/asdf-kafka/actions/workflows/lint.yml)


[kafka](https://github.com/ueisele/asdf-kafka) plugin for the [asdf version manager](https://asdf-vm.com).

The plugin supports `Confluent Enterprise`, `Confluent Community` and `Apache` releases.

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `sed`, `tar`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add kafka https://github.com/ueisele/asdf-kafka.git
```

kafka:

```shell
# Show all installable versions
asdf list-all kafka
asdf list-all kafka confluent-enterprise
asdf list-all kafka confluent-community
asdf list-all kafka apache

# Install specific version
asdf install kafka latest:confluent-enterprise
asdf install kafka latest:confluent-community
asdf install kafka latest:apache

# Set a version globally (on your ~/.tool-versions file)
asdf global kafka latest:confluent-enterprise
asdf global kafka latest:confluent-community
asdf global kafka latest:apache

# Now kafka commands are available
kafka-topics --help

# Set a version for the current shell
asdf shell kafka latest:confluent-enterprise
asdf shell kafka latest:confluent-community
asdf shell kafka latest:apache
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/ueisele/asdf-kafka/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Uwe Eisele](https://github.com/ueisele/)
