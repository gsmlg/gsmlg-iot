target ?= host
key = $(shell mix phx.gen.secret)
ssid ?= n/a
psk ?= n/a

build:
	export MIX_TARGET=$(target) ;\
		export MIX_ENV=prod ;\
		export SECRET_KEY_BASE=$(key) ;\
		export NERVES_NETWORK_SSID=$(ssid) ;\
		export NERVES_NETWORK_PSK=$(psk) ;\
		mix firmware ;\
		mix firmware.burn

deps:
	export MIX_TARGET=$(target) ;\
		export MIX_ENV=prod ;\
		export SECRET_KEY_BASE=$(key) ;\
		mix deps.get

