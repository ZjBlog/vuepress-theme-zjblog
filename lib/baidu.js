import axios from 'axios'

export default function baiduPush(href) {
    console.info('........baidu:'+href)
    axios.post('http://data.zz.baidu.com/urls?site=https://zjblog.github.io&token=LgjiDKj7OTFJniBy', href, {
        headers: { 'Content-Type': 'text/plain' }
    }).then(res => {
        console.info('成功')
        console.info(res)
    }).catch((res)=>{
        console.info('失败')
        console.info(res)
    })
}