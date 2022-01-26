# Анализатор качества репозиториев

[![Actions Status](https://github.com/DimaKabanov/rails-project-lvl4/workflows/hexlet-check/badge.svg)](https://github.com/DimaKabanov/rails-project-lvl4/actions)
[![check](https://github.com/DimaKabanov/rails-project-lvl4/actions/workflows/check.yml/badge.svg)](https://github.com/DimaKabanov/rails-project-lvl4/actions/workflows/check.yml)

## Описание

Проект, который помогает автоматически следить за качеством репозиториев на гитхабе. Он отслеживает изменения и прогоняет их через встроенные анализаторы. Затем формирует отчеты и отправляет их пользователю. 

[Demo app]()

## Системные требования

* Ruby
* Node.js
* Yarn
* SQLite3
* [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#download-and-install)

## Установка

```sh
make setup
make test # run tests
make start # run server http://localhost:3000
```