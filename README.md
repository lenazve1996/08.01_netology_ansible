# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

        ansible-playbook -i inventory/test.yml site.yml
    > `some_fact` имеет значение "12"

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
    
    > Поменяла. Теперь если запустить команду playbook для test.yml, значение `some_fact` будет равным строке 'all default fact'.
    
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
        
        docker run -d -i --name centos7 centos:7
        docker run -d -i --name ubuntu matthewfeickert/docker-python3-ubuntu:3.10.5

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
    
        ansible-playbook -i inventory/prod.yml site.yml
        TASK [Print fact] **************************************************************
        ok: [centos7] => {
            "msg": "el"
        }
        ok: [ubuntu] => {
            "msg": "deb"
        }

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

        ​ansible-playbook -i inventory/prod.yml site.yml
        TASK [Print fact] **************************************************************
        ok: [centos7] => {
            "msg": "el default fact"
        }
        ok: [ubuntu] => {
            "msg": "deb default fact"
        }
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

    >Применяю команду, указанную ниже, к двум значениям и копирую ее вывод в файл с фактами.

        ansible-vault encrypt_string

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
    >Работает.

    ![ansible-vault](https://github.com/lenazve1996/08.01_netology_ansible/blob/main/img/ansible-vault.png)
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

        ansible-doc -t connection -l
    > Для хостов из файла prod.yml подходящий тип соединения - community.docker.docker. Для хоста из файла test.yml подходящий тип соединения - local.

    

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

    >Добавляем следующие строки в файл:
    ```yml
    local:
        hosts:
            localhost:
                ansible_connection: local
    ```

11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
    >Факты определены верно.

    ![ansible on prod hosts](https://github.com/lenazve1996/08.01_netology_ansible/blob/main/img/ansible%20on%20prod%20hosts.png)
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.

    > Расшифровываю следующим образом:

        echo '$ANSIBLE_VAULT;1.1;AES256
        61666261346234316335666631633466356532336239306333613234636565633964656237323339
        3366396537303864363962393935306639313066366334640a333032616633313061666563653539
        38386239393838306662386664613832613662373236326366313131653037336134346636316535
        6337336435316637310a356535363563366130396562623335343563623362646530626664626234
        30303634393938303733333362373039393261666264336566393161663265633430' | ansible-vault decrypt
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
    
        ansible-vault encrypt_string
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
    >Новый fact применился для localhost.

        ![ansible-vault-password](https://github.com/lenazve1996/08.01_netology_ansible/blob/main/img/ansible-vault-password.png)
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).
    >Добавлена.
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
    
    >Скрипт лежит в корне репозитория - scripr.sh. После выполнения команды `sh script.sh` понадобится ввести пароль от vault - `netology`.
6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

---
