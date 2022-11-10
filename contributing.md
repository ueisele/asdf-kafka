# Contributing

Testing scrips:

```shell
bin/list-all
test/test-download.sh confluent-community-7.3.0
test/test-install.sh confluent-community-7.3.0
```

Testing locally with asdf:

```shell
asdf plugin test kafka https://github.com/ueisele/asdf-kafka.git --asdf-plugin-gitref main --asdf-tool-version latest:confluent-community "kafka-topics --version || (kafka-topics; [[ \$? -eq 1 ]])"
```

Tests are automatically run in GitHub Actions on push and PR.
