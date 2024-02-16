CPATH='.;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
if [[ -f "student-submission/ListExamples.java" ]]
then
    echo "File found!"
else
    echo "ListExamples.java not found!"
    exit 1
fi

#move jar files, TestListExamples.java, and ListExamples.java to grading-area
cp TestListExamples.java grading-area/
cp -r lib grading-area/
cp student-submission/ListExamples.java grading-area/

cd grading-area

javac -cp $CPATH *.java 2> trash-file.txt 

if [[ $? -ne 0 ]]
then 
    echo "Compile error!"
    exit 1;
else
    echo "Compiled successfully!"
fi

javac -cp $CPATH TestListExamples.java
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > output-testing.txt

if grep -q "Failures:" output-testing.txt; then
    errCount=$(grep "Failures" output-testing.txt | awk '{print $5}')
    totalCount=$(grep "run:" output-testing.txt | awk -F'[, ]' '{print $3}')
    echo "Error count: $errCount"
    successes=$((totalCount - errCount))
    echo "Your grade is $successes / $totalCount"
elif grep -1 "OK (" output-testing.txt; then 
    echo "Total Grade: 100"
else
    echo "Error occurred while calculating test grades"
fi

