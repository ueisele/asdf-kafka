# Contributing

Testing Locally:

```shell
asdf plugin test kafka https://github.com/ueisele/asdf-kafka.git --asdf-plugin-gitref main --asdf-tool-version latest:confluent-community "kafka-topics --version"
```

Tests are automatically run in GitHub Actions on push and PR.
