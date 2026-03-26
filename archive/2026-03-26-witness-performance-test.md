# Witness performance test 2026-03-26

```
$ git clone https://git.glasklar.is/sigsum/core/sigsum-go.git
$ cd sigsum-go/
$ cd tests/
$ ./setup-env 
$ ./bin/sigsum-key generate -o test.log.key
$ cat test.log.key.pub | sigsum-key to-hex
```

Then added that test log key to the witness configuration for each
witness that was to be tested.

Created two add-checkpoint requests:

```
$ go run ./mk-add-checkpoint-request 0 2 < test.log.key > tmp-checkpoint-0-to-2
$ go run ./mk-add-checkpoint-request 2 2 < test.log.key > tmp-checkpoint-2-to-2
```

Do add-checkpoint for the tmp-checkpoint-0-to-2 once first:

```
$ cat tmp-checkpoint-0-to-2 | curl -s -w '%{content_type}\n%{http_code}\n' --data-binary @- $witness_url/add-checkpoint
```

Then ran a script like this:

```
# Set witness_url here
witness_url=https://bastion.glasklar.is/26983895bdf491838dd4885848670562e7b728b6efa15fd9047b5b97a9a0618f # stage-witness.glasklar.is
#witness_url=https://witness1.smartit.nu/witness1 # witness1.smartit.nu/witness1

for n_parallel_requests in `seq 5 5 80`
do
    echo
    echo n_parallel_requests = $n_parallel_requests
    rm -f tmp-stdout tmp-stderr
    N=2
    for i in `seq 1 $N`
    do
	time_before=`date +%s.%N`
	for k in `seq 1 $n_parallel_requests`
	do
	    cat tmp-checkpoint-2-to-2 | curl -s -w '%{content_type}\n%{http_code}\n' --data-binary @- $witness_url/add-checkpoint 1>> tmp-stdout 2>> tmp-stderr &
	done
	wait
	time_after=`date +%s.%N`
	requests_per_second=`echo "$n_parallel_requests / ($time_after - $time_before)" | bc -l`
	echo requests_per_second = $requests_per_second
    done
    success_count=`cat tmp-stdout | grep 200 | wc -l`
    ((expected_success_count=n_parallel_requests*N))
    success_rate=`echo "100 * $success_count / $expected_success_count" | bc -l`
    echo "success_rate = $success_rate %"
done
```

## Results for witness1.smartit.nu/witness1 (x86_64 with soft key)

```
n_parallel_requests = 5
requests_per_second = 145.93114489929495994102
requests_per_second = 151.68346040210739292141
success_rate = 100.00000000000000000000 %

n_parallel_requests = 10
requests_per_second = 190.52961498023093294407
requests_per_second = 191.19610389756890521168
success_rate = 100.00000000000000000000 %

n_parallel_requests = 15
requests_per_second = 226.10952395624376729097
requests_per_second = 203.95821711964087037129
success_rate = 100.00000000000000000000 %

n_parallel_requests = 20
requests_per_second = 243.54252475323601650059
requests_per_second = 217.03021325345348241688
success_rate = 100.00000000000000000000 %

n_parallel_requests = 25
requests_per_second = 239.31151952036304591337
requests_per_second = 223.69537657537357105518
success_rate = 100.00000000000000000000 %

n_parallel_requests = 30
requests_per_second = 251.50731899292814235528
requests_per_second = 265.19427036110336940281
success_rate = 100.00000000000000000000 %

n_parallel_requests = 35
requests_per_second = 270.89150502660858897274
requests_per_second = 242.69763048339931565370
success_rate = 100.00000000000000000000 %

n_parallel_requests = 40
requests_per_second = 260.07714746448383223260
requests_per_second = 268.47258870035654904851
success_rate = 100.00000000000000000000 %

n_parallel_requests = 45
requests_per_second = 262.34843933898057587896
requests_per_second = 277.83323466343257256584
success_rate = 100.00000000000000000000 %

n_parallel_requests = 50
requests_per_second = 280.01030146698684985941
requests_per_second = 285.69816254255274142357
success_rate = 100.00000000000000000000 %

n_parallel_requests = 55
requests_per_second = 291.08598034707070572139
requests_per_second = 260.18488406717415491772
success_rate = 100.00000000000000000000 %

n_parallel_requests = 60
requests_per_second = 278.28159759183268370890
requests_per_second = 285.10924587996231692089
success_rate = 100.00000000000000000000 %

n_parallel_requests = 65
requests_per_second = 292.08659582077825314097
requests_per_second = 252.59047955161350504299
success_rate = 100.00000000000000000000 %

n_parallel_requests = 70
requests_per_second = 267.92000153709532310424
requests_per_second = 263.78748306611541966303
success_rate = 100.00000000000000000000 %

n_parallel_requests = 75
requests_per_second = 283.12299522022699533365
requests_per_second = 231.78822816260287870286
success_rate = 100.00000000000000000000 %

n_parallel_requests = 80
requests_per_second = 295.98110273131879567390
requests_per_second = 283.59539361532260806986
success_rate = 100.00000000000000000000 %
```

## Results for stage-witness.glasklar.is (RPi with YubiHSM)

```
n_parallel_requests = 5
requests_per_second = 8.74345117692710953727
requests_per_second = 8.37334825280894768759
success_rate = 100.00000000000000000000 %

n_parallel_requests = 10
requests_per_second = 9.26905085285394284313
requests_per_second = 9.32253144417839565966
success_rate = 100.00000000000000000000 %

n_parallel_requests = 15
requests_per_second = 9.44761907084519431257
requests_per_second = 9.42174556665038538783
success_rate = 100.00000000000000000000 %

n_parallel_requests = 20
requests_per_second = 9.53903247509042878778
requests_per_second = 9.52171089792028975800
success_rate = 100.00000000000000000000 %

n_parallel_requests = 25
requests_per_second = 9.56997420806586756312
requests_per_second = 9.59673750847140007638
success_rate = 100.00000000000000000000 %

n_parallel_requests = 30
requests_per_second = 9.63335774692709302323
requests_per_second = 9.63529529531819238341
success_rate = 100.00000000000000000000 %

n_parallel_requests = 35
requests_per_second = 9.64842369674538550367
requests_per_second = 9.67297884418430329429
success_rate = 100.00000000000000000000 %

n_parallel_requests = 40
requests_per_second = 9.70373329317184543733
requests_per_second = 9.66056311661022629989
success_rate = 100.00000000000000000000 %

n_parallel_requests = 45
requests_per_second = 9.70519318203527669627
requests_per_second = 9.69137507458528022227
success_rate = 100.00000000000000000000 %

n_parallel_requests = 50
requests_per_second = 9.74846354392970647316
requests_per_second = 9.70552025796410995469
success_rate = 100.00000000000000000000 %

n_parallel_requests = 55
requests_per_second = 10.65079672444452520287
requests_per_second = 10.65569943332990413551
success_rate = 86.36363636363636363636 %

n_parallel_requests = 60
requests_per_second = 11.58286888564463198883
requests_per_second = 11.58433235120829493353
success_rate = 60.00000000000000000000 %

n_parallel_requests = 65
requests_per_second = 12.54322312434049939937
requests_per_second = 12.53098219560206082628
success_rate = 22.30769230769230769230 %

n_parallel_requests = 70
requests_per_second = 13.45325033829985336057
requests_per_second = 13.46022935587038861950
success_rate = 0 %

n_parallel_requests = 75
requests_per_second = 14.35992293198618027975
requests_per_second = 14.37267356551650575481
success_rate = .66666666666666666666 %

n_parallel_requests = 80
requests_per_second = 15.26810705234099494776
requests_per_second = 15.28293705216280606265
success_rate = 0 %
```
