<template>
    <div class="footer">
        <div class="bo">
        <a v-if="$site.themeConfig.zjurl.length>0" :href="$site.themeConfig.zjurl[0].url"  target="_blank" style="color:white">{{$site.themeConfig.zjurl[0].name}}</a>
        <a v-if="$site.themeConfig.zjemail" style="color:white"  href="javascript:void(0)" @click="sendmail" id='copy' :data-clipboard-text="$site.themeConfig.zjemail">
        <i class="fa fa-envelope fa-2x" aria-hidden="true"></i></a>
        <a v-if="$site.themeConfig.zjgithub" :href="$site.themeConfig.zjgithub"  target="_blank" style="color:white">
        <i class="fa fa-github fa-2x" aria-hidden="true"></i></a>
        <a v-if="$site.themeConfig.zjoverflow" :href="$site.themeConfig.zjoverflow"  target="_blank" style="color:white">
        <i class="fa fa-stack-overflow fa-2x" aria-hidden="true"></i></a>
        <a v-if="$site.themeConfig.zjurl.length>1" :href="$site.themeConfig.zjurl[1].url"  target="_blank" style="color:white">{{$site.themeConfig.zjurl[1].name}}</a>
        <a v-if="$site.themeConfig.cnzzUrl" :href="url"  target="_blank" style="color:white">
           <img src="https://icon.cnzz.com/img/2.gif">
        </a>
        </div>
        <canvas id="c"></canvas>
    </div>
</template>
<script>
import 'font-awesome/css/font-awesome.css'
import {aa} from '../lib/common.js'
import Clipboard from 'clipboard'
export default {
  name: 'footerblog',
  data () {
    return {
      url: ''
    }
  },
  mounted () {
    aa()
    if(this.$site.themeConfig.cnzzUrl){
      let web_id=this.$site.themeConfig.cnzzUrl.substring(this.$site.themeConfig.cnzzUrl.lastIndexOf('=')+1)
      this.url='https://new.cnzz.com/v1/login.php?siteid=' + web_id
    }
  },
  methods: {
    sendmail () {
      let clipboard = new Clipboard('#copy')
      clipboard.on('success', e => {
        clipboard.destroy()
        window.alert('邮箱复制成功,欢迎发邮件给我!!!')
      })
      clipboard.on('error', e => {
        clipboard.destroy()
        window.alert('欢迎发邮件给我 :  zhangjun521ly@gmail.com ')
      })
    }
  }
}
</script>
<style  lang="less" scoped>
canvas{
  position: absolute;
  cursor: crosshair;
  width:100%;
  height:100px;
  }
.footer {
    position: relative;
    background-size: 150%;
    width: 100%;
    height: 100px;
    .bo {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 10;
    background: rgba(0, 0, 0, 0.4);
    line-height: 100px;
    text-align: center;
    font-size: 20px;
    color: #fff;    
     a {
       padding: 10px;
      }
    }
}
</style>
