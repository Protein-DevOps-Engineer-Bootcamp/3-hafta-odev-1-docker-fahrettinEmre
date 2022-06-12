## 3.Hafta 1.Odev
---

### Açıklama
1. Kullanici build edilen image icin `image name` ve `image tag` verebilir.

2. Kullanici kendi yerelinde bu docker image'i calistirabilir image'i calistirken `memory` ve `cpu` limitleri tanımlayabilir. Herhangi bir limit belirtilmedigi surece default olarak hicbir limit belirtilmeden çalışır.

3. Kullanıcı dockerhub veya gitlab 'a register etmek için öncelikle login yapılmalıdır.

4. Kullanıcı `sql` ve `mongo` servislerini ayaga kaldirabilir. Docker compose dosyasi icinde `memory` ve `cpu` limitlemesi yapılmıştır.Ek olarak o limitleri aşar ise şu kadar daha kullan diye ek limit sunulmuştur.

---
#### Yazilan script'in 3 tane modu vardır (*build*, *deploy*, *template* ) bu 3 mod birbirinden bagimsizdir.
##### Build Modu
- Örneğin; ./main.sh -m build -n deneme -t v2

##### Deploy Mod
- Örneğin; ./main.sh -m deploy -n deneme -t v1 -e 500mb -p 1

##### Template Mod
- Örneğin ; ./main.sh -m template -a sql


### Usage:
```shell

$ main.sh

Usage:
-m        <mode>             <build-deploy-template>             
-n        <name>             İmage name Exp: -n imagename                                   
-t        <tag>              İmage Tag  Exp: -t tagname
-r        <registary>        For push Dockerhub or Gitlab Exp: -r dockerhub        
-e        <memory>           If this parameter is not given, it works by default. Exp: -e 1g 
-p        <cpu>              If this parameter is not given, it works by default. Exp: -p 1
-a        <applicationname>  sql or mongo Exp: -a sql
```