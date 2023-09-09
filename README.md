# README

## How to run it on your local

1/ Install `mkcert` (https://github.com/FiloSottile/mkcert)

2/ Install dependencies and run
```
mkcert -i # this will install two certificates files at the project root folder as trusted on your localhost

bundle install

rails s -b 'ssl://0.0.0.0:3000?cert=localhost.pem&key=localhost-key.pem&verify_mode=none'

```

3/ Visit: `https://localhost:3000`

## Libraries used:

+ Bootstrap

+ Devise

+ Xero Ruby

+ Kaminari (for pagination)

+ RSpec

+ Factory Bot

## Notes

+ UI is very simple, just to demonstrate the main workflow

+ There is only 1 test for the main method in User model which fetch invoices. We can totally add more if needed

+ There is a ActiveJob for fetching invoices and it is called in the callback. We could also use it at other places if needed

## Rooms for improvement

+ Make the UX a bit better (like show loading icon while fetching data, or show data in real-time while sync)

+ More error handling

+ Better UI