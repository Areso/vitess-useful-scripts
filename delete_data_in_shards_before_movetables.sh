for n in $(kubectl --namespace vitess get pods | grep vttablet | awk '{print $1}')
do
  kubectl exec -n vitess -it pods/$n -c mysqld -- mysql -u root -S /vt/socket/mysql.sock --binary-as-hex=false --database=_vt -e 'delete from vreplication_log where id>1;'
  kubectl exec -n vitess -it pods/$n -c mysqld -- mysql -u root -S /vt/socket/mysql.sock --binary-as-hex=false --database=_vt -e 'update vreplication set pos="" where id=1;'
  kubectl exec -n vitess -it pods/$n -c mysqld -- mysql -u root -S /vt/socket/mysql.sock --binary-as-hex=false --database=_vt -e 'update vreplication set transaction_timestamp=0 where id=1;'
done
