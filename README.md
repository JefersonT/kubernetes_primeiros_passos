# Kubernetes Primeiros Passos
Este projeto foi desenvolvido com o objetivo de praticar os conhecimentos adquiridos nos cursos de Kubernetes da Alura.
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
- Acesse ao arquivo *portal-configmap.yaml* na pasta **portal-noticias/Configmaps** e faça a seguinte alteração:
    - DE:
        ```
        .
        .
        .

        data:
            IP_SISTEMA: http://192.168.59.100:30001
        ```
    - PARA:
        ```
        .
        .
        .

        data:
            IP_SISTEMA: http://localhost:30001
        ```
- Acesse ao arquivo *stress.sh* na pasta **portal-noticias/StatefulSets/TestesHPA** e faça a seguinte alteração:
    - DE:
        ```
        #!/bin/bash
        for i in {1..10000}; do
            curl 192.168.59.100:30000
            sleep $1
        done
        ```
    - PARA:
        ```
        #!/bin/bash
        for i in {1..10000}; do
            curl localhost:30000
            sleep $1
        done
        ```
### Linux
- Execute o seguite comando e anote o INTERNAL-IP do minikube:
    ```
    kubectl get nodes -o wide
    ```
- Acesse ao arquivo *portal-configmap.yaml* na pasta **portal-noticias/Configmaps** e faça a seguinte alteração, substituindo o ip atual pelo ip do minikube anotado anteriormente, mantendo a porta 30001:
    - DE:
        ```
        .
        .
        .

        data:
            IP_SISTEMA: http://192.168.59.100:30001
        ```
    - PARA:
        ```
        .
        .
        .

        data:
            IP_SISTEMA: http://INTERNAL-IP_MINIKUBE:30001
        ```
- Acesse ao arquivo *stress.sh* na pasta **portal-noticias/StatefulSets/TestesHPA** e faça a seguinte alteração:
    - DE:
        ```
        #!/bin/bash
        for i in {1..10000}; do
            curl 192.168.59.100:30000
            sleep $1
        done
        ```
    - PARA:
        ```
        #!/bin/bash
        for i in {1..10000}; do
            curl <INTERNAL-IP_MINIKUBE>:30000
            sleep $1
        done
        ```
## Executando o projeto
- Configurar o servidor de métricas
    - Windows:
        - No diretório raiz do projeto execute o comando:
        ```
        $ kubectl apply -f portal-noticias/StatefulSets/TestesHPA/components.yaml
        ```
    - Linux:
        - Ative o servidor de métricas dentro do minikube com o seguinte comando:
            ```
            $ minikube addons enable metrics-server
            ```
- Crie cada um dos elementos da pasta **portal-noticias**
    - Entre na pasta raiz do projeto.
    - Execute os seguintes comandos para o iniciar projeto com StatefulSets:
        ```
        $ kubectl apply -f portal-noticias/Services/ --all
        $ kubectl apply -f portal-noticias/StatefulSets/ --all
        $ kubectl apply -f portal-noticias/Configmaps/ --all
        ```
    - **OU** execute os seguintes comandos para iniciar o projeto com Deployments:
        ```
        $ kubectl apply -f portal-noticias/Services/ --all
        $ kubectl apply -f portal-noticias/Deployments/ --all
        $ kubectl apply -f portal-noticias/Configmaps/ --all
        ```
    - **OU** execute os seguintes comandos para iniciar o projeto com Pods:
        ```
        $ kubectl apply -f portal-noticias/Services/ --all
        $ kubectl apply -f portal-noticias/Pods/ --all
        $ kubectl apply -f portal-noticias/Configmaps/ --all
        ```
- Windows:
    - Para testar o Sistema e o Portal acesse ao http://localhost:30000 e http://localhost:30001
    - Para tester o funcionamento do HPA execute o arqiuvo *stress.sh* através do GitBash:
        ```
        $ bash stress.sh
        ```
        - Acompanhe as mudançado do HPA através do comando:
            ```
            $ kubectl get hpa --watch
            ```
        - Para encerrar o teste pare a execução do arquivo *stress.sh* (Ctrl+C).
- Linux:
    - Para testar o Sistema e o Portal acesse ao http://INTERNAL-IP-MINIKUBE:30000 e http://INTERNAL-IP-MINIKUBE:30001
    - Para tester o funcionamento do HPA execute o arquivo *stress.sh* através do Bash:
        ```
        $ bash stress.sh
        ```
        - Acompanhe as mudançado do HPA através do comando:
            ```
            $ kubectl get hpa --watch
            ```
        - Para encerrar o teste pare a execução do arquivo *stress.sh* (Ctrl+C).
- No link com a porta 30001 faça login com usuário e senha `admin`.
- Cadastre uma notícia a seu gosto.
- Acesse ao link com porta 30000, atualize e confira se a notícia cadastrada é carregada.
- Ao finalizar os teste com StatesfulSets execute os comandos:
    ```
    $ kubectl delete -f portal-noticias/Services/ --all
    $ kubectl delete -f portal-noticias/StatesfulSets/ --all
    $ kubectl delete -f portal-noticias/Configmaps/ --all
    ```
- **OU** execute os comandos abaixo caso o projeto tenha sido iniciado com Deployments:
    ```
    $ kubectl delete -f portal-noticias/Services/ --all
    $ kubectl delete -f portal-noticias/Deployments/ --all
    $ kubectl delete -f portal-noticias/Configmaps/ --all
    ```
- **OU** execute os comandos abaixo caso o projeto tenha sido iniciado com Pods:
    ```
    $ kubectl delete -f portal-noticias/Services/ --all
    $ kubectl delete -f portal-noticias/Pods/ --all
    $ kubectl delete -f portal-noticias/Configmaps/ --all
    ```

## Anotações
- O Kubernetes não é apenas um orquestrador de containers, ele também terá o papel de criar e gerenciar toda a infraestrutura do Cluster. O Kubernetes irá atuar na criação e gerenciamento das máquinas do clusters, assim como na orquestração de containers em cada máquina, além de garantir a escabilidade do cluster sendo capas de criar e configurar máquinas para suportar a demanda até mesmo destruir para não consumir recursos desnecessário. Tudo isso independênte do provedor cloud ou da ferramenta de containers.
- **PODS**: 
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
- **Services (SVCs)**:
    - São responsáveis por prover abstrações para expor aplicações executando em um ou mais pods.
    - Proveem IP's fixos para comunicação
    - Proveem um DNS para um ou mais pods
    - São capazes de fazer balanceamento de carga.
    - Tipos:
        - ClusterIP
        - NodePort
        - LoadBalancer
    - **ClusterIP**:
        - Será responsável pela comunicação entre os pods dentro de um mesmo cluster.
        - Irá identificar os pods a ser servidos apartir das labels declaradas em cada pods, sendo referenciado no Service.
        - Onde irá mapear as portas dos pods nas portas do Service.
        - Exemplo com os arquivos *pod-2.yaml* e *svc-pod-2.yaml* presetentes na pasta **service**.
    - **NodePort**:
        - Permite a comunicação de uma máquina fora do cluster com um node ou pod dentro dele.
        - Também funciona como ClusterIP, permitindo a comunicação interna também.
        - Para acessar um pod no ambiente linux é acessado pelo *ip_minicube:porta_configurada*.
        - Para acessar um pod no ambiente windows é acessado pelo *localhost:porta_configurada*.
        - Exemplo com os arquivos *pod-1.yaml* e *svc-pod-1.yaml* presetentes na pasta **service**.
    - **LoadBalancer**:
        - É um ClusterIP que também permite a comunicação de uma máquina externa com o pods do cluster.
        - Automaticamente se integra ao LoadBalancerdo nosso cloud provider.
        - Exemplo de arquivo: *svc-pod-1-loadbalance.yaml* presetente na pasta **service**. Não aplicavel no ambiente local.
- **Utilizando variáveis de ambiente**
    - Uma das forma de utilizar variáveis de ambiente é declarando as variáveis diretamente o arquivo de criação do pod. Ex.:
        ```
        .
        .
        .
        
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
- **Replica Set**:
    - Pode emcapsular um ou mais pods.
    - Ele pode gerenciar diversos pods, caso algum pod venha a finalizar, o replica set é responsável por criar um novo pod similar ao que foi finalizado.
    - Comando para listar os Replica Sets:
        ```
        $ kubectl get rs
        ```
- **Deployment**
    - O deployment cria um replicaset.
    - A estrutura do arquivo é igual, salvo que o kind é Deployment.
    - O maior diferencial e vantagem do deployment é que ele permite o versionamento do nosso replica set. Mantendo uma lista de versões e permitindo restar o replicaset para alguma versão anterio.
    - Comando para listar os Replica Sets:
        ```
        $ kubectl get deployments
        ```
    - O replicaset criado pelo deployments também pode ser listado com o comando `$ kubectl get rs`.
    - Comando para listar o histórico de versões do deployment:
        ```
        $ kubectl rollout history deployment nome-deployment
        ```
    - Comando para gravar uma nova versão após realizar alguma alteração no deployment:
        ```
        $ kubectl apply -f arquivo-deployment.yaml --record
        ```
        Issor irá reconfigurar os pods e gravar a nova versão do deployment, ao executar o comando `kubectl rollout history deployment nome-deployment` podemos observar uma nova linha.
    - Comando para alterar a descrição da ultima versão registrada:
        ```
        $ kubectl annotate deploy nome-deployment kubernetes.io/change-cause="Nova descriação da versão"

        OU

        $ kubectl annotate deployment nome-deployment kubernetes.io/change-cause="Nova descriação da versão"
        ```
    - Comando para retornar para uma versão específica do deployment:
        ```
        $ kubectl rollout undo deployment nome-deployment --to-revision=Nº-DA-VERSÃO
        ```
- **Persistência de dados**
    - **Volumes**
        - Volumes possuem ciclo de vida dependentes de Pods e independentes de containers.
        - Funcionam assim como funciona com o Docker.
    - **PersistVolume(PV) e PersistentVolumeClaim(PVC)**
        - Com o PersistVolume iremos cria e manipular o o disco no nosso cloud provider. E com o PersistentVolumeClaim iremos manipular as informações acessando o PersistentVolume. Dessa foram os Pods deveram declarar o acesso ao PersistentVolumeClaim onde iram manipular os discos do cloud provider através do PersistentVolume.
    - **StorageClass(SC)**
        - Os Storages Classes torna o trabalho do PV e PVC dinâmico. Criando um StorageClass não há a necessidade de criar um disco do cloud provider e nem o PV, ambos são criados e removidos dinamicamente. Assim só há a necessidade de criar o PVC onde serão definidos as configurações do disco a ser criado e referenciar o SC no campo `storageClassName:`. Os teste com arquivos aqui presente devem ser feito direto do seu Cloud Provider. Finalizando o SC automaticamente finaliza o PV e o disco.
    - **StatefulSet**
        - O StatefulSet funciona de forma semelhante ao Deployment, e sua criação também se assemelha como o mesmo, porém com um algumas diferenças. Uma delas é que o StatefulSet necessita declarar qual o Serviço é responsável com gerenciar seus pods, além disso, seu principal diferencial é que permite a persistễncia de dados mesmo com os pods sendo finalizado. Portanto para o funcionamento correto da percistência é necessaŕio criar um PVC com as configurações do volume, assim na criação do StatefulSet é criado o volume referenciando o PVC. Com o StatefulSet os PVs e os espaço em disco são criados automaticamente.
- **Probes**
    - A principal utilidade dos Probes é tornar visível ao Kubernetes que uma aplicação não está se comportando da maneira esperada.
    - **Liveness Probes**
        - O Liveness Probes é como uma sonda que detecta e trata quando o serviço dentro de um container para de funcionar de forma correta. Com ele definimos o intervalo de tempo entre cada verificação do statos do serviço, qual end-point será verificado, quantas falhas serão toleradas antes do reinício do serviço e quando o monitoramento vai iniciar após o start do container. Ele verifica a saúde do serviço pelo código html, sendo que se for maior que 200 e menor que 400 indicar sucesso caso contrário fálha.
    - **Readiness Probes**
        - O Readiness probes permite garantir que o pod esteja pronto para receber requisições, enquanto não estiver ele não permite entrada de requisições para o pod. Assim como no Liveness, com o Readiness configuramos um tempo para iniciar as verificações, o interválo de tempo entre as verificações, qual end-point será verificado e quantas falhas serão toleradas antes de permitir que o pod receber as requisições.
    - **Startup Probes**
        - Há um terceiro tipo de probe voltado para aplicações legadas, o Startup Probe. Algumas aplicações legadas exigem tempo adicional para inicializar na primeira vez. Nem sempre Liveness ou Readiness Probes vão conseguir resolver de maneira simples os problemas de inicialização de aplicações legadas.
- **Horizontal Pod Autoscaling**
    - O HorizontalPodAutoscaling permite configurar-mos limites de usu de recursos específicos como cpu e memória, onde ao atinger este limite, automaticamente são adicionados pods para atender a demanda ou remove os pods quando não há a utilização dos recursos acima do limite estabelecido. Nele também é configurável a quantidade mínima e máxima de pods a serem mantidos para atender aos limites.
    - Pré-requisitos:
        - É necessário configurar o limite de recursos no container do objeto criado, para que haja um parametro de comparação para HorizontalPodAutoscaling.
        - Deve ser configurado um servidor de métricas (apresentado no inicio da página).
- **Vertical Pod Autoscaler**
    - Além do HorizontalPodAutoscaler, o Kubernetes possui um recurso customizado chamado VerticalPodAutoscaler. O VerticalPodAutoscaler remove a necessidade de definir limites e pedidos por recursos do sistema, como cpu e memória. Quando definido, ele define os consumos de maneira automática baseada na utilização em cada um dos nós, além disso, quanto tem disponível ainda de recurso. Algumas configurações extras são necessárias para utilizar o VerticalPodAutoscaler.

- **Comandos Extras**:
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