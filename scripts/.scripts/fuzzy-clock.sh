declare -a N_array
N_array=(zero one two three four five six seven eight nine ten eleven twelve )

H=$(date '+%l')
M=$(date '+%M')

hour=${N_array[${H}]}

if (( $M > 52 )); then
  time="${N_array[${H}]} o'clock"

elif (( $M > 38 )); then
  time="quarter to ${N_array[${H}]}"

elif (( $M > 22 )); then
  time="${N_array[${H}]} thirty"

elif (( $M > 8 )); then
  time="quarter after ${N_array[${H}]}"

else
  time="${N_array[${H}]} o'clock"

fi

echo $time

