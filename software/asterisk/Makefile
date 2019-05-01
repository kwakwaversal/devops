# Save asterisk config files that might have been worked on within the docker
# containers over the original repo files. Arguably this could be done by
# volume mounting the files but I prefer this approach as any changes can be
# easily discarded by killing the container.
#
# Usage:
# 	make --always-make # always rebuild any targets

carrierfiles := ${shell echo carrier/*.conf}
testboxfiles := ${shell echo testbox/*.conf}

all: $(carrierfiles) $(testboxfiles)

carrier/%.conf:
	docker-compose exec asterisk-carrier cat /etc/asterisk/$*.conf | dos2unix > carrier/$*.conf

testbox/%.conf:
	docker-compose exec asterisk-testbox cat /etc/asterisk/$*.conf | dos2unix > testbox/$*.conf

packages:
	sudo apt-get install -y dos2unix

.PHONY: packages
