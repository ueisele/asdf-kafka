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

## Plugin

- `bash`, `curl`, `sed`, `tar`, generic POSIX utilities.

## Kafka

Kafka requires Java. Depending of the installed release, different versions are recommended and supported.
The minimum supported version is still Java 8. However it has been deprecated in Apache Kafka 3.0.0 and Confluent Platform 7.0.0. Java 8 will be removed in Confluent Platform 8.

* Starting from Apache Kafka 3.1.0 and Confluent 7.1.0 Java 17 is the recommended version.
* Starting from Apache Kafka 2.1.0 and Confluent 5.1.0 Java 11 is the recommended version.
* Starting from Apache Kafka 1.0.0 and Confluent 4.0.0 Java 9 is the recommended version.

Also see:
* https://kafka.apache.org/downloads
* https://docs.confluent.io/platform/current/installation/versions-interoperability.html#java

You can install Java using [asdf-java plugin](https://github.com/halcyon/asdf-java).

```bash
asdf plugin add java https://github.com/halcyon/asdf-java.git
asdf install java latest:zulu-17
asdf global java latest:zulu-17
```

## 

# Install

Plugin:

```bash
asdf plugin add kafka https://github.com/ueisele/asdf-kafka.git
```

Kafka:

```bash
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
asdf shell kafka apache-3.3.1
asdf shell kafka confluent-community-7.3.0
asdf shell kafka confluent-enterprise-7.3.0
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/ueisele/asdf-kafka/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Uwe Eisele](https://github.com/ueisele/)
