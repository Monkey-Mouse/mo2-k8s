swapoff -a
images=(  # 下面的镜像应该去除"k8s.gcr.io/"的前缀版本换成上面获取到的版本
    kube-apiserver:v1.21.0
    kube-controller-manager:v1.21.0
    kube-scheduler:v1.21.0
    kube-proxy:v1.21.0
    pause:3.4.1
    etcd:3.4.13-0
    coredns/coredns:1.8.0
    bitnami/metrics-server:0.4.1
)

for imageName in ${images[@]} ; do
    if test $imageName = "bitnami/metrics-server:0.4.1"; then
        docker pull $imageName
        docker tag $imageName k8s.gcr.io/metrics-server/metrics-server:v0.4.1
        docker rmi $imageName
    elif test $imageName = "coredns/coredns:1.8.0"; then
        docker pull $imageName
        docker tag $imageName k8s.gcr.io/coredns/coredns:v1.8.0
        docker rmi $imageName
    else
        docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
        docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
        docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
    fi
done
kubeadm init -v=30 --kubernetes-version=v1.21.0 --pod-network-cidr=10.244.0.0/16 --apiserver-cert-extra-sans=47.93.189.12
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f https://raw.fastgit.org/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/pythianarora/total-practice/master/sample-kubernetes-code/metrics-server.yaml
kubectl taint nodes --all node-role.kubernetes.io/master-
