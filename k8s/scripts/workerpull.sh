swapoff -a
images=(  # 下面的镜像应该去除"k8s.gcr.io/"的前缀版本换成上面获取到的版本
    kube-proxy:v1.21.0
    pause:3.4.1
    bitnami/metrics-server:0.4.1
)

for imageName in ${images[@]} ; do
    if test $imageName = "bitnami/metrics-server:0.4.1"; then
        docker pull $imageName
        docker tag $imageName k8s.gcr.io/metrics-server/metrics-server:v0.4.1
        docker rmi $imageName
    else
        docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
        docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
        docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
    fi
done