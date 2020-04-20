# Makefile to generate all necessary certificates and keys for SSL communication using Docker-ized cfssl tool
# based on https://github.com/etcd-io/etcd/tree/master/hack/tls-setup

# If you wish to download and install cfssl tool locally using Go instead of using Docker containers,
# switch the comments for ".PHONY", "CFSSL", "JSON" and "all" sections, and uncomment "cfssl" section 


#.PHONY: cfssl ca etcd api dashboard agent grafana clean
.PHONY: ca etcd api dashboard agent grafana clean 

#CFSSL	= @env PATH=$(GOPATH)/bin:$(PATH) cfssl
#JSON	= env PATH=$(GOPATH)/bin:$(PATH) cfssljson
CFSSL	= docker run --rm --name cfssl -v $(CURDIR):/go/src/github.com/cloudflare/cfssl cfssl/cfssl:latest
JSON	= docker run --rm --name cfssljson --entrypoint=cfssljson -v $(CURDIR):/go/src/github.com/cloudflare/cfssl cfssl/cfssl:latest

#all: cfssl ca etcd api dashboard agent grafana
all: ca etcd api dashboard agent grafana

#cfssl:
#	go get -u -tags nopkcs11 github.com/cloudflare/cfssl/cmd/cfssl
#	go get -u github.com/cloudflare/cfssl/cmd/cfssljson
#	go get -u github.com/mattn/goreman

ca:
	# create CA key and cert as a temporary JSON file
	$(CFSSL) gencert -initca ca/ca-csr.json > ca/ca-cert.json
	# convert the CA key and cert JSON file into separate PEM files
	$(JSON) -bare -f ca/ca-cert.json ./ca/ca
	# combine key and cert into one file
	cat ca/ca.pem ca/ca-key.pem > ca/ca-combined.pem
	# trash the temporary JSON file
	rm ca/ca-cert.json

etcd:
	# generate sensu-backend-1 etcd cert using same temporary JSON file method as above in CA
	$(CFSSL) gencert \
	  -ca ca/ca.pem \
	  -ca-key ca/ca-key.pem \
	  -config ca/ca-config.json \
	  etcd/etcd-csr.json > etcd/etcd-cert.json
	$(JSON) -bare -f etcd/etcd-cert.json etcd/sensu-backend-1
	# combine key and cert into one file
	cat etcd/sensu-backend-1.pem etcd/sensu-backend-1-key.pem > etcd/sensu-backend-1-combined.pem
	rm etcd/etcd-cert.json
	
	# generate sensu-backend-2 etcd cert
	$(CFSSL) gencert \
	  -ca ca/ca.pem \
	  -ca-key ca/ca-key.pem \
	  -config ca/ca-config.json \
	  etcd/etcd-csr.json > etcd/etcd-cert.json
	$(JSON) -bare -f etcd/etcd-cert.json etcd/sensu-backend-2
	cat etcd/sensu-backend-2.pem etcd/sensu-backend-2-key.pem > etcd/sensu-backend-2-combined.pem
	rm etcd/etcd-cert.json
	
	# generate sensu-backend-3 etcd cert
	$(CFSSL) gencert \
	  -ca ca/ca.pem \
	  -ca-key ca/ca-key.pem \
	  -config ca/ca-config.json \
	  etcd/etcd-csr.json > etcd/etcd-cert.json
	$(JSON) -bare -f etcd/etcd-cert.json etcd/sensu-backend-3
	cat etcd/sensu-backend-3.pem etcd/sensu-backend-3-key.pem > etcd/sensu-backend-3-combined.pem
	rm etcd/etcd-cert.json

api:
	# generate sensu-backend-1 api cert using same temporary JSON file method as above in CA
	$(CFSSL) gencert \
	  -ca ca/ca.pem \
	  -ca-key ca/ca-key.pem \
	  -config ca/ca-config.json \
	  api/api-csr.json > api/api-cert.json
	$(JSON) -bare -f api/api-cert.json api/sensu-backend-1
	cat api/sensu-backend-1.pem api/sensu-backend-1-key.pem > api/sensu-backend-1-combined.pem
	rm api/api-cert.json
	
	# generate sensu-backend-2 api cert
	$(CFSSL) gencert \
	  -ca ca/ca.pem \
	  -ca-key ca/ca-key.pem \
	  -config ca/ca-config.json \
	  api/api-csr.json > api/api-cert.json
	$(JSON) -bare -f api/api-cert.json api/sensu-backend-2
	cat api/sensu-backend-2.pem api/sensu-backend-2-key.pem > api/sensu-backend-2-combined.pem
	rm api/api-cert.json
	
	# generate sensu-backend-3 api cert
	$(CFSSL) gencert \
	  -ca ca/ca.pem \
	  -ca-key ca/ca-key.pem \
	  -config ca/ca-config.json \
	  api/api-csr.json > api/api-cert.json
	$(JSON) -bare -f api/api-cert.json api/sensu-backend-3
	cat api/sensu-backend-3.pem api/sensu-backend-3-key.pem > api/sensu-backend-3-combined.pem
	rm api/api-cert.json

dashboard:
	# generate webUI dashboard cert
	$(CFSSL) gencert \
	  -ca ca/ca.pem \
	  -ca-key ca/ca-key.pem \
	  -config ca/ca-config.json \
	  dashboard/dashboard-csr.json > dashboard/dashboard-cert.json
	$(JSON) -bare -f dashboard/dashboard-cert.json dashboard/dashboard
	cat dashboard/dashboard.pem dashboard/dashboard-key.pem > dashboard/dashboard-combined.pem
	rm dashboard/dashboard-cert.json

agent:
	# generate sensu-agent agent cert using same temporary JSON file method as above in CA
	$(CFSSL) gencert \
	  -ca ca/ca.pem \
	  -ca-key ca/ca-key.pem \
	  -config ca/ca-config.json \
	  agent/sensu-agent-csr.json > agent/sensu-agent-cert.json
	$(JSON) -bare -f agent/sensu-agent-cert.json agent/sensu-agent
	cat agent/sensu-agent.pem agent/sensu-agent-key.pem > agent/sensu-agent-combined.pem
	rm agent/sensu-agent-cert.json
	
	$(CFSSL) gencert \
	  -ca ca/ca.pem \
	  -ca-key ca/ca-key.pem \
	  -config ca/ca-config.json \
	  agent/sensu-agent-centos-1-csr.json > agent/sensu-agent-centos-1-cert.json
	$(JSON) -bare -f agent/sensu-agent-centos-1-cert.json agent/sensu-agent-centos-1
	cat agent/sensu-agent-centos-1.pem agent/sensu-agent-centos-1-key.pem > agent/sensu-agent-centos-1-combined.pem
	rm agent/sensu-agent-centos-1-cert.json
	
	$(CFSSL) gencert \
	  -ca ca/ca.pem \
	  -ca-key ca/ca-key.pem \
	  -config ca/ca-config.json \
	  agent/sensu-agent-centos-2-csr.json > agent/sensu-agent-centos-2-cert.json
	$(JSON) -bare -f agent/sensu-agent-centos-2-cert.json agent/sensu-agent-centos-2
	cat agent/sensu-agent-centos-2.pem agent/sensu-agent-centos-2-key.pem > agent/sensu-agent-centos-2-combined.pem
	rm agent/sensu-agent-centos-2-cert.json
	
	# combine the Sensu Agent certs into one file to used by Sensu Backends
	cat agent/sensu-agent.pem agent/sensu-agent-centos-1.pem agent/sensu-agent-centos-2.pem > agent/all.pem
	# combine the Sensu Agent keys into another file to used by Sensu Backends
	cat agent/sensu-agent-key.pem agent/sensu-agent-centos-1-key.pem agent/sensu-agent-centos-2-key.pem > agent/all-key.pem
	# combine the Sensu Agent combined cert/key pairs into one file to be used by HAproxy
	cat agent/sensu-agent-*combined.pem > agent/all-combined.pem

grafana:
	# generate webUI grafana cert
	$(CFSSL) gencert \
	  -ca ca/ca.pem \
	  -ca-key ca/ca-key.pem \
	  -config ca/ca-config.json \
	  grafana/grafana-csr.json > grafana/grafana-cert.json
	$(JSON) -bare -f grafana/grafana-cert.json grafana/grafana
	cat grafana/grafana.pem grafana/grafana-key.pem > grafana/grafana-combined.pem
	cat dashboard/dashboard-combined.pem grafana/grafana-combined.pem > haproxy/dashboard-grafana-combined.pem
	rm grafana/grafana-cert.json

clean:
	rm -rf ca/*.pem ca/*.csr etcd/*.pem etcd/*.csr api/*.pem api/*.csr dashboard/*.pem dashboard/*.csr agent/*.pem agent/*.csr grafana/*.pem grafana/*.csr
