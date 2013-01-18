.PHONY: deps rel stagedevrel

all: deps compile

compile:
	./rebar compile

deps:
	./rebar get-deps

clean:
	./rebar clean

distclean: clean devclean relclean
	./rebar delete-deps

test:
	./test.sh

eunit:
	./test.sh

rel: all
	./rebar generate

relclean:
	rm -rf rel/zont

devrel: dev1 dev2 dev3

###
### Docs
###
docs:
	./rebar skip_deps=true doc

##
## Developer targets
##

stage : rel
	$(foreach dep,$(wildcard deps/* wildcard apps/*), rm -rf rel/zont/lib/$(shell basename $(dep))-* && ln -sf $(abspath $(dep)) rel/zont/lib;)


stagedevrel: dev1 dev2 dev3
	$(foreach dev,$^,\
	  $(foreach dep,$(wildcard deps/* wildcard apps/*), rm -rf dev/$(dev)/lib/$(shell basename $(dep))-* && ln -sf $(abspath $(dep)) dev/$(dev)/lib;))

devrel: dev1 dev2 dev3


devclean:
	rm -rf dev

dev1 dev2 dev3: all
	mkdir -p dev
	(cd rel && ../rebar generate target_dir=../dev/$@ overlay_vars=vars/$@.config)


##
## Dialyzer
##
APPS = kernel stdlib sasl erts ssl tools os_mon runtime_tools crypto inets \
	xmerl webtool snmp public_key mnesia eunit syntax_tools compiler
COMBO_PLT = $(HOME)/.zont_combo_dialyzer_plt

check_plt: deps compile
	dialyzer --check_plt --plt $(COMBO_PLT) --apps $(APPS) \
		-r deps/*/ebin

build_plt: deps compile
	dialyzer --build_plt --output_plt $(COMBO_PLT) --apps $(APPS) \
		-r deps/*/ebin

dialyzer: deps compile
	@echo
	@echo Use "'make check_plt'" to check PLT prior to using this target.
	@echo Use "'make build_plt'" to build PLT prior to using this target.
	@echo
	@sleep 1
	dialyzer --plt $(COMBO_PLT) deps/*/ebin


cleanplt:
	@echo 
	@echo "Are you sure?  It takes about 1/2 hour to re-build."
	@echo Deleting $(COMBO_PLT) in 5 seconds.
	@echo 
	sleep 5
	rm $(COMBO_PLT)
