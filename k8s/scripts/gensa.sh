# your server name goes here
server=https://123.57.249.127:6443
# the name of the secret containing the service account token goes here
name=exp-admin-token-w6ptd
namespace=exp

ca=$(kubectl get secret/$name -n $namespace -o jsonpath='{.data.ca\.crt}')
token=$(kubectl get secret/$name -n $namespace -o jsonpath='{.data.token}' | base64 --decode)


echo "
apiVersion: v1
kind: Config
clusters:
- name: default-cluster
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: default-context
  context:
    cluster: default-cluster
    namespace: ${namespace}
    user: default-user
current-context: default-context
users:
- name: default-user
  user:
    token: ${token}
" > sa.kubeconfig