- container_name_network_view.sh - Сопоставление имени контейнера и сетевого интерфейса
- diskmanagr.sh - Создание новых vg group и lv volume (Запускать так ./diskmanagr.sh /dev/sdb vgdocker lvdocker /var/lib/docker)
- lvm-extend.sh - Добавление нового диска в существующий lvm. Здесь lun=новый диск, который нужно добавить (Запускать так ./lvm-extend.sh /dev/sdb vgdocker lvdocker /var/lib/docker)
- lvm-reduce.sh - Уменьшение lvm c миграцией на другой том. Здечь lun=диск с которого будем уезжать, и который будем удалять (Запускать так ./lvm-reduce.sh /dev/sdb vgdocker lvdocker /var/lib/docker 9G)
- check_app_swap.sh - Определяем приложения которые пользуют swap
- docker_install_centos7.sh - Установка докера на CentOs7
- docker_install_oel8.sh - Установка докера на OEL8
- useradd.sh - Создание нового пользователя
- rancher-exporter.sh - Старая версия экспортера написанная на bash (работоспособен, но требует много ресурсов, при большом количестве кластеров кубера)
- docker_lvm.sh - Создание lv для докера.
- k8s_prom_to_zbx.sh - Скрипт для забикса, который выдергивает данные с севера промитея или виктории.