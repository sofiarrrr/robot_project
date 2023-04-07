# robot_project
A server with flask tested by robot, functional and performance test


> xmRobotTestFunctional.robot : test for the first assignment <br>
> xmRobotTestPerformance.robot : test for the performance test

* functional.py : runs the flask server (it is called from inside each test) <br>
            ```#time.sleep(random.uniform(0.2, 0.5))```
            this must be uncommented to run Performance Test 
* used the html+css+<js script inside html for writing output> from the original site 

* Once the site is called, creates a flask-web-log.csv where server collects log with all the incoming requests for each url and response code.<br>
(I uploaded an example from my test)
