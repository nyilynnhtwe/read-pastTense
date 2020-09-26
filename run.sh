#! /usr/bin/bash
echo "Enter the links or books you have read(You have to enter valid book names or links):"
read units
now=$(date +"%T")
loopControl=exit
whSpace=
while [[ "$units" != "$loopControl" ]]
do
   if [[ "$units" == "$whSpace" ]]
   then
	   echo "You have entered empty string(You have to enter valid book names or links)"
   else
	   mongo 127.0.0.1/readingDB --eval 'var document = { _id : getNextSequenceValue("productid") ,name : "'"${units}"'" , date : "'"${now}"'" }; function getNextSequenceValue(sequenceName){
   var sequenceDocument = db.counters.findAndModify({
      query:{_id: sequenceName },
      update: {$inc:{sequence_value:1}},
      new:true
   });
   return sequenceDocument.sequence_value;
}; db.lists.insert(document);' &> /dev/null
	   echo $units Saved time:  "$now">> read.txt
           echo "Done saving.Enter 'exit' keyword if you finish reading!"
   fi
   read units
   now=$(date +"%T")
done
