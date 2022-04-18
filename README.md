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
- Criando pods de forma Descritiva:
    - Esta forma se trata de crialo apartir de um arquivo .yaml ou .jason.
    - Neste projeto há um exemplo, *primeiro_pod.yaml*, com código comentando especificando as informações necessárias para execução.
    - Feito o arquivo basta executar o comando:
        ```
        $ kubectl apply -f .\caminho\do\arquivo.yaml
        ```
    - Desta forma, caso seja necessário alterar as configurações do Pods, basta alterar a informação no arquivo e executar o comando acima novamente. Não será criado um novo, mas será reiniciado com as novas configurações.
