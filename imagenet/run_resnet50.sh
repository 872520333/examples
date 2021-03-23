git clone https://github.com/872520333/examples.git ${WORKSPACE}/resbet50
cd ${WORKSPACE}/resbet50/imagenet
git checkout enable_nhwc
git pull
for var in $@
    do
        case $var in
            --model=*)
                model=$(echo $var |cut -f2 -d=)
            ;;
	    --precision=*)
                precision=$(echo $var |cut -f2 -d=)
            ;;
	    --data_path=*)
                data_path=$(echo $var |cut -f2 -d=)
            ;;
	    --model_path=*)
                model_path=$(echo $var |cut -f2 -d=)
            ;;
	    --work_space=*)
                work_space=$(echo $var |cut -f2 -d=)
            ;;


            *)
                echo "Error: No such parameter: ${var}"
                exit 1
            ;;
        esac
    done

./run_multi_instance_ipex.sh ${model} ${precision} ${data_path}


throughput=$(grep 'Throughput:' ./inference_cpu* |sed -e 's/.*Throughput//;s/[^0-9.]//g' |awk '
BEGIN {
        sum = 0;
      }
      {
        sum = sum + $1;
      }
END   {
        printf("%.2f", sum);
}')
echo "${model};"inference";${precision};${throughput}" | tee -a ${work_space}/summary.log
