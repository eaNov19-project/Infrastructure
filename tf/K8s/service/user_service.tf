apiVersion: v1
kind: Service
metadata:
  name: user-ms-svc
spec:
  type: NodePort
  selector:
    app: user-ms
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080