1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.<br />
<b>git show aefea</b><br>
commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545<br>
Update CHANGELOG.md


2. Какому тегу соответствует коммит 85024d3?<br>
<b>git show 85024d3</b><br>
commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)


3. Сколько родителей у коммита b8d720? Напишите их хеши.<br>
<b>git show b8d720</b><br>
commit b8d720f8340221f2146e4e4870bf2ee0bc48f2d5<br>
Merge: 56cd7859e 9ea88f22f<br>
<b>git show 56cd7859e</b><br>
commit 56cd7859e05c36c06b56d013b55a252d0bb7e158<br>
<b>git show 9ea88f22f</b><br>
commit 9ea88f22fc6269854151c571162c5bcf958bee2b


4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.<br>
<b>git log  v0.12.23..v0.12.24</b><br>
commit <b>33ff1c03bb960b332be3af2e333462dde88b279e</b> (tag: v0.12.24)<br>
    v0.12.24<br>
commit <b>b14b74c4939dcab573326f4e3ee2a62e23e12f89</b><br>
    [Website] vmc provider links<br>
commit <b>3f235065b9347a758efadc92295b540ee0a5e26e</b><br>
    Update CHANGELOG.md<br>
commit <b>6ae64e247b332925b872447e9ce869657281c2bf</b><br>
    registry: Fix panic when server is unreachable<br>
    Non-HTTP errors previously resulted in a panic due to dereferencing the<br>
    resp pointer while it was nil, as part of rendering the error message.<br>
    This commit changes the error message formatting to cope with a nil<br>
    response, and extends test coverage.<br>
    Fixes #24384<br>
commit <b>5c619ca1baf2e21a155fcdb4c264cc9e24a2a353</b><br>
    website: Remove links to the getting started guide's old location<br>
    Since these links were in the soon-to-be-deprecated 0.11 language section, I<br>
    think we can just remove them without needing to find an equivalent link.<br>
commit <b>06275647e2b53d97d4f0a19a0fec11f6d69820b5</b><br>
    Update CHANGELOG.md<br>
commit <b>d5f9411f5108260320064349b757f55c09bc4b80</b><br>
    command: Fix bug when using terraform login on Windows<br>
commit <b>4b6d06cc5dcb78af637bbb19c198faff37a066ed</b><br>
    Update CHANGELOG.md<br>
commit <b>dd01a35078f040ca984cdd349f18d0b67e486c35</b><br>
    Update CHANGELOG.md<br>
commit <b>225466bc3e5f35baa5d07197bbc079345b77525e</b><br>
    Cleanup after v0.12.23 release


5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).<br>
<b>git log -S"func providerSource("</b><br>
commit 8c928e83589d90a031f811fae52a81be7153e82f


6. Найдите все коммиты в которых была изменена функция globalPluginDirs.<br>
<b>git log -L :'func globalPluginDirs':plugins.go</b><br>
commit 78b122055<br>
commit 52dbf9483<br>
commit 41ab0aef7<br>
commit 66ebff90c<br>
commit 8364383c3


7. Кто автор функции synchronizedWriters?<br>
<b>git log -S"synchronizedWriters"</b><br>
commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5<br>
Author: Martin Atkins <mart@degeneration.co.uk><br>
Date:   Wed May 3 16:25:41 2017 -0700
