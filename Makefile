.PHONY: gentocs
gentocs:
	go run sigs.k8s.io/mdtoc@v1.4.0 --inplace log.md
