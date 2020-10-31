# CS3MI3
##### Shivam Taneja
 [Prolog, Scala, Ruby, and Clojure](#download)

### A1
[Readme](https://github.com/TANEJS4/CS3MI3/tree/main/a1)
### H1
To run test cases, invoke `amm h1_test.sc`

### <a name="H2"></a>H2
* To run test cases, invoke `swipl -t "load_test_files([]), run_tests." -s h2.pl`
* [Docker automated testing](#docker)



### <a name="H3"></a>H3
* To run test cases, invoke `amm h3t.sc` for scala section and `swipl -t "load_test_files([]), run_tests." -s h3.pl` for prolog 
* [Docker automated testing](#docker)


### <a name="H4"></a>H4
* To run test cases, invoke `amm h4t.sc`
* [Docker automated testing](#docker)


### <a name="H5"></a>H5
* To run test cases, invoke `ruby h5t.rb`
* [Docker automated testing](#docker)

### <a name="H6"></a>H6
To be added

### <a name="docker"></a>Docker
For Docker automated testing, invoke `setup.sh` and then `run.sh`. scripts assumes that you are in a bash like shell. 
This works with [H2](#H2), [H3](#H3), [H4](#H4), [H5](#H5).

## <a name="download"></a>BoilerPlate

Scala - 
*   [Scala](https://scala-lang.org/) version 2.13 and
*    [Ammonite](https://ammonite.io/), an “improved” Scala REPL (read, evaluate, print loop), version 1.7.1,

* [lolhens/ammonite](https://hub.docker.com/r/lolhens/ammonite/) Docker image.

Prolog -
 * [SWI Prolog](https://www.swi-prolog.org/) version 8.2.0, as used in the [swipl](https://hub.docker.com/_/swipl/) Docker image.  

Ruby - 
* Try `ruby -v` from your terminal of choice to confirm.
    
* Otherwise, or if you want a different version, see the [Ruby installation guide](https://www.ruby-lang.org/en/documentation/installation/#rubyinstaller). 
