## Pŕe-requisitos
### Instalações necessárias (Linux)
- VirtualBox
- Kubernetes:
    - [Kubectl](https://kubernetes.io/releases/download/)
    - [Minikube](https://minikube.sigs.k8s.io/docs/start/)
        - Deve ser iniciado sempre que for utilizar:
            ```
            $ minikube start --vm-driver=virtualbox
            ```
### Instalações necessárioas (Windows)
- Docker Desktop
    - Ativar recursos do Kubernetes

## Pré-configurações do Projeto
### Windows
- Acesse ao arquivo *portal-configmap.yaml* na pasta **portal-noticias** e faça a seguinte alteração:
    - DE:
        ```
        ...
        data:
            IP_SISTEMA: http://192.168.59.100:30001
        ```
    - PARA:
        ```
        ...
        data:
            IP_SISTEMA: http://localhost:30001
        ```
### Linux
- Execute o seguite comando e anote o INTERNAL-IP do minikube:
    ```
    kubectl get nodes -o wide
    ```
- Acesse ao arquivo *portal-configmap.yaml* na pasta **portal-noticias** e faça a seguinte alteração, substituindo o ip atual pelo ip do minikube anotado anteriormente, mantendo a porta 30001:
    - DE:
        ```
        ...
        data:
            IP_SISTEMA: http://192.168.59.100:30001
        ```
    - PARA:
        ```
        ...
        data:
            IP_SISTEMA: http://INTERNAL-IP_MINIKUBE:30001
        ```
## Executando o projeto
- Crie cada um dos elementos da pasta **portal-noticias**
    - Entre na pasta raiz do projeto.
    - Execute os seguintes comandos:
        ```
        $ kubectl apply -f portal-noticias/db-configmap.yaml
        $ kubectl apply -f portal-noticias/portal-configmap.yaml
        $ kubectl apply -f portal-noticias/sistema-configmap.yaml
        $ kubectl apply -f portal-noticias/db-noticias.yaml
        $ kubectl apply -f portal-noticias/portal-noticias.yaml
        $ kubectl apply -f portal-noticias/sistema-noticias.yaml
        $ kubectl apply -f portal-noticias/svc-db-noticias.yaml
        $ kubectl apply -f portal-noticias/svc-pod-portal-noticias.yaml
        $ kubectl apply -f portal-noticias/svc-sistema-noticias.yaml
        ```
- Windows:
    - Acesse ao http://localhost:30000 e http://localhost:30001
- Linux:
    - Acesse ao http://INTERNAL-IP-MINIKUBE:30000 e http://INTERNAL-IP-MINIKUBE:30001
- No link com a porta 30001 faça login com usuário e senha `admin`.
- Cadastre uma notícia a seu gosto.
- Acesse ao link com porta 30000, atualize e confira se a notícia cadastrada é carregada.
- Ao finalizar os teste execute os comandos:
    ```
    $ kubectl delete -f portal-noticias/db-configmap.yaml
    $ kubectl delete -f portal-noticias/portal-configmap.yaml
    $ kubectl delete -f portal-noticias/sistema-configmap.yaml        
    $ kubectl delete -f portal-noticias/db-noticias.yaml
    $ kubectl delete -f portal-noticias/portal-noticias.yaml
    $ kubectl delete -f portal-noticias/sistema-noticias.yaml
    $ kubectl delete -f portal-noticias/svc-db-noticias.yaml
    $ kubectl delete -f portal-noticias/svc-pod-portal-noticias.yaml
    $ kubectl delete -f portal-noticias/svc-sistema-noticias.yaml
    ```

## Anotações
- O Kubernetes não é apenas um orquestrador de containers, ele também terá o papel de criar e gerenciar toda a infraestrutura do Cluster. O Kubernetes irá atuar na criação e gerenciamento das máquinas do clusters, assim como na orquestração de containers em cada máquina, além de garantir a escabilidade do cluster sendo capas de criar e configurar máquinas para suportar a demanda até mesmo destruir para não consumir recursos desnecessário. Tudo isso independênte do provedor cloud ou da ferramenta de containers.
- PODS: 
    - São equivalentes a containes, porém é um encapsulamento, podendo contar mais de um container dentro dela.
    - Na criação do pod lhe é associado um ip, não sendo mais associado um ip ao container, de forma que o container é acessado apartir de uma porta específica do pod.
    - Os pods são efemeros. Ao destruir um e criar outro, o novo não se torna uma recriação do antigo.
    - Quando os contains do pod param de funcionar o pods é finalizado e o Kubernet fica responsável por criar um novo pod com o container necessário.
    - Os containers presente em um pod compartilham os namespace de rede e IPC (processos) e podem compartilhar o mesmo Volume
- Criando e manipulando pods de forma Interativa:
    - Para criar um pod basta executar o comando:
        ```
        $ kubeclt run nginx-pod --image=nginx:latest
        ```
        - Onde `nginx-pod` é o nome do pod a ser criado e o `--image=nginx:latest` indica a imagem a ser usada e sua versão.
    - Para visalizar os pod em execução:
        ```
        $ kubectl get pods
        ```
    - Adicionando a flag `--watch` ao final do comando acima, irá mostra a evolução do status dos pods:
        ```
        $ kubectl get pods --watch
        ```
    - Para buscar mais informações sobre o pod criado basta executar o comando:
        ```
        $ kubectl describe pod nginx-pod
        ```
        - Onde `nginx-pod` é o nome do pode
    - Podemos modificar algumas configurações dos pods, por exemplo a versão da imagem, através do comando:
        ```
        $ kubectl edit pod nginx-pod
        ```
        - Onde `nginx-pod` é o nome do pode.
        - Ele iŕa abrir um arquivo com as configurções do pod, dessa forma basta edita-lo e salvar. OBS.: pode quebrar o funcionamento do pode editando dessa forma.
    - Para finalizar o pod interativo, basta executar o seguinte comando:
        ```
        $ kubectl delete pod nginx-pod
        ```
        - Onde `nginx-pod` é o nome do pode.
- Criando pods de forma Descritiva:
    - Esta forma se trata de crialo apartir de um arquivo .yaml ou .jason.
    - Neste projeto há um exemplo, *primeiro_pod.yaml* na pasta **pods**, com código comentando especificando as informações necessárias para execução.
    - Feito o arquivo basta executar o comando:
        ```
        $ kubectl apply -f .\caminho\do\arquivo.yaml
        ```
    - Desta forma, caso seja necessário alterar as configurações do Pods, basta alterar a informação no arquivo e executar o comando acima novamente. Não será criado um novo, mas será reiniciado com as novas configurações.
    - Para acessar um pods de formas interativa, basta executar o comanto:
        ```
        kubectl exec -it nome_pods -- bash
        ```
    - Para finalizar o pode descritivo, basta executar o comando:
        ```
        $ kubectl delete -f .\caminho\do\arquivo.yaml
        ```
- SVC (Services):
    - São responsáveis por prover abstrações para expor aplicações executando em um ou mais pods.
    - Proveem IP's fixos para comunicação
    - Proveem um DNS para um ou mais pods
    - São capazes de fazer balanceamento de carga.
    - Tipos:
        - ClusterIP
        - NodePort
        - LoadBalancer
    - ClusterIP:
        - Será responsável pela comunicação entre os pods dentro de um mesmo cluster.
        - Irá identificar os pods a ser servidos apartir das labels declaradas em cada pods, sendo referenciado no Service.
        - Onde irá mapear as portas dos pods nas portas do Service.
        - Exemplo com os arquivos *pod-2.yaml* e *svc-pod-2.yaml* presetentes na pasta **service**.
    - NodePort:
        - Permite a comunicação de uma máquina fora do cluster com um node ou pod dentro dele.
        - Também funciona como ClusterIP, permitindo a comunicação interna também.
        - Para acessar um pod no ambiente linux é acessado pelo *ip_minicube:porta_configurada*.
        - Para acessar um pod no ambiente windows é acessado pelo *localhost:porta_configurada*.
        - Exemplo com os arquivos *pod-1.yaml* e *svc-pod-1.yaml* presetentes na pasta **service**.
    - LoadBalancer:
        - É um ClusterIP que também permite a comunicação de uma máquina externa com o pods do cluster.
        - Automaticamente se integra ao LoadBalancerdo nosso cloud provider.
        - Exemplo de arquivo: *svc-pod-1-loadbalance.yaml* presetente na pasta **service**. Não aplicavel no ambiente local.
- Utilizando variáveis de ambiente
    - Uma das forma de utilizar variáveis de ambiente é declarando as variáveis diretamente o arquivo de criação do pod. Ex.:
        ```
        spec:
            containers:
                - name: db-noticias-container
                    image: aluracursos/mysql-db:1
                    ports:
                        - containerPort: 3306
                    # com o env: é possível passar variveis de ambente
                    # para o container que esta sendo criado no pod
                    # de forma pa passar o nome e o valor de cada variavel como mostra abaixo
                    env:
                        - name: "MYSQL_ROOT_PASSWORD" # Nome da varivável
                            value: "mudar@123" # Valor da variável
                        - name: "MYSQL_DATABASE"
                            value: "empresa"
                        - name: "MYSQL_PASSWORD"
                            value: "mudar@123"
        ```
    - A outra forma mais coveniênte e organizada é criando um ConfigMap, é uma estrutura que ficará responsável específicamente por manter variáveis de ambiente, a qual deve ser referencaiada na criação do container. E deve ser criada assim como os Services e PODs. Exemplos na pasta **portal-noticias/** com os arquivos *...-configmap.yaml* e os arquivos *...-noticias.yaml*.
- Comandos Extras:
    - Finalizar todos os pods:
        ```
        $ kubectl delete pods --all
        ```
    - Finalizar todos os serviços:
        ```
        $ kubectl delete svc --all
        ```
    - Listar pods:
        ```
        $ kubectl get pods
        ```
    - Listar pods com informações extras:
        ```
        $ kubectl get pods -o wide
        ```
    - Listar serviços:
        ```
        $ kubectl get svc
        ```
    - Listar serviços com mais informaçẽos:
        ```
        $ kubectl get svc -o wide
        ```
    - Listar os nodes em geral:
        ```
        $ kubectl get nodes
        ```
    - Listar nodes com informações extras:
        ```
        $ kubectl get nodes -o wide
        ```