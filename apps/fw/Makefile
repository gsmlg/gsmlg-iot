target ?= host
key = $(shell mix phx.gen.secret)

build:
	export MIX_TARGET=$(target) ;\
		export MIX_ENV=prod ;\
		export SECRET_KEY_BASE=$(key) ;\
		mix firmware ;\
		mix firmware.burn

deps:
	export MIX_TARGET=$(target) ;\
		export MIX_ENV=prod ;\
		export SECRET_KEY_BASE=$(key) ;\
		mix deps.get

