<div align="center">

# asdf-kafka [![Build](https://github.com/ueisele/asdf-kafka/actions/workflows/build.yml/badge.svg)](https://github.com/ueisele/asdf-kafka/actions/workflows/build.yml) [![Lint](https://github.com/ueisele/asdf-kafka/actions/workflows/lint.yml/badge.svg)](https://github.com/ueisele/asdf-kafka/actions/workflows/lint.yml)


[kafka](https://github.com/ueisele/asdf-kafka) plugin for the [asdf version manager](https://asdf-vm.com).

The plugin supports `Apache`, `Confluent Community` and `Confluent Enterprise` releases.

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
asdf list-all kafka apache
asdf list-all kafka confluent-community
asdf list-all kafka confluent-enterprise

# Install specific version
asdf install kafka latest:apache
asdf install kafka latest:confluent-community
asdf install kafka latest:confluent-enterprise

# Set a version globally (on your ~/.tool-versions file)
asdf global kafka latest:apache
asdf global kafka latest:confluent-community
asdf global kafka latest:confluent-enterprise

# Now kafka commands are available
kafka-topics --version

# Set a version for the current shell
asdf shell kafka latest:apache
asdf shell kafka latest:confluent-community
asdf shell kafka latest:confluent-enterprise
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/ueisele/asdf-kafka/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Uwe Eisele](https://github.com/ueisele/)
