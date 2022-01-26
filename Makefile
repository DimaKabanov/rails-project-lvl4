install:
	bundle install

start:
	bin/rails s -p 3000 -b "0.0.0.0"

test:
	NODE_ENV=test bin/rails test

lint:
	bundle exec rubocop

linter-fix:
	bundle exec rubocop -A

slim-lint:
	slim-lint app/views

deploy:
	git push heroku main

setup:
	cp -n .env.example .env || true
	bin/setup
	bin/rails db:fixtures:load

check: lint test

.PHONY: test