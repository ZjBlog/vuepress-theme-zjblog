<template>
  <transition-group name="right">
    <div :key="key2" class="card github-card" v-if="show && $site.themeConfig.zjwx">
      <img :src="$withBase($site.themeConfig.zjwx)" style="width:250px;height:270px;"/>
    </div>
    <div class="card github-card" v-if="show1 && web" :key="key1">
          <img :src="src">
      <h1>扫一扫手机阅读</h1>
    </div>
  </transition-group>
</template>

<script>
const urlMap = {
  repoTab: '?tab=repositories',
  followersTab: '?tab=followers'
}

export default {
  name: "github-card",
  data() {
    return {
      show: false,
      show1: false,
      name: "暴躁DPS",
      userUrl: 'https://github.com/ZjBlog',
      avatar: 'https://avatars1.githubusercontent.com/u/15625370?v=4',
      repoNum: null,
      repoUrl: null,
      followersNum: null,
      followersUrl: null,
      gistsNum: null,
      gistsUrl: null,
      code: 1,
      web:true,
      src: 'https://www.bangechengzi.com/qrcode?text=https://zjblog.github.io/'
    };
  },
    watch: {
    '$route': 'change'
  },
  mounted() {
    this.src = 'https://www.bangechengzi.com/qrcode?text=' + window.location.href
    this.web = this.isWeb()
    this.changeShow()
    // if (!this.user) return;
    // this.githubUserInfo(this.user).then(this.githubInfoHandle);
  },
  computed: {
    key1() {
        return this.code  + 'key1'
    },
    key2() {
        return this.code + 'key2'
    },
    user() {
      const { themeConfig } = this.$site;
      return themeConfig.github
    }
  },
  methods: {
    isWeb () {
      let sUserAgent = navigator.userAgent.toLowerCase()
      let bIsIpad = sUserAgent.match(/ipad/i) == "ipad"
      let bIsIphoneOs = sUserAgent.match(/iphone os/i) == "iphone os"
      let bIsMidp = sUserAgent.match(/midp/i) == "midp"
      let bIsUc7 = sUserAgent.match(/rv:1.2.3.4/i) == "rv:1.2.3.4"
      let bIsUc = sUserAgent.match(/ucweb/i) == "ucweb"
      let bIsAndroid = sUserAgent.match(/android/i) == "android"
      let bIsCE = sUserAgent.match(/windows ce/i) == "windows ce"
      let bIsWM = sUserAgent.match(/windows mobile/i) == "windows mobile"
      if (bIsIpad || bIsIphoneOs || bIsMidp || bIsUc7 || bIsUc || bIsAndroid || bIsCE || bIsWM) { 
          return false   
      }else{
        return true
      }
    },
    change () {
      this.code = Date.now()
    },
    changeShow () {
      let vm = this
      let timeId = setTimeout(function () {
        if (vm.show) {
           clearTimeout(timeId)
        } else {
          vm.show = true
        }
      }, 1000)
      let timeId1 = setTimeout(function () {
        if (vm.show1) {
          clearTimeout(timeId1)
        } else {
          vm.show1 = true
        }
      }, 2000)
    },
    githubUserInfo(user) {
      return fetch(`https://api.github.com/users/${user}`)
        .then(data => {
          this.show = true
          return data.text()
        })
        .then(text => JSON.parse(text));
    },
    githubInfoHandle(userInfo) {
      const {
        avatar_url,
        name,
        html_url,
        followers,
        public_gists,
        public_repos
      } = userInfo;
      this.avatar = avatar_url;
      this.name = name;
      this.userUrl = html_url;
      this.repoNum = public_repos;
      this.repoUrl = `${html_url}${urlMap.repoTab}`;
      this.followersNum = followers;
      this.followersUrl = `${html_url}${urlMap.followersTab}`;
      this.gistsNum = public_gists;
      this.gistsUrl = `https://gist.github.com/${this.user}`;
    }
  }
};
</script>

<style src="../styles/transition.styl" lang="stylus"></style>
<style src="../styles/card.styl" lang="stylus"></style>
<style lang="stylus">
@import '../styles/config.styl';

  .xwcms {
    -webkit-transition: -webkit-transform 2s ease-out;
    -moz-transition: -moz-transform 2s ease-out;
    -o-transition: -o-transform 2s ease-out;
    -ms-transition: -ms-transform 2s ease-out;
  }
  .xwcms:hover {
    -webkit-transform: rotateZ(360deg);
    -moz-transform: rotateZ(360deg);
    -o-transform: rotateZ(360deg);
    -ms-transform: rotateZ(360deg);
    transform: rotateZ(360deg);
  }

.github-card {
  text-align: center;
  max-width: $toolWidth;

  h1 {
    font-size: 16px;
    font-weight: 500;
    text-decoration: none;
    margin-top:-9px;
  }
}

.github-header {
  height: 128px;
  position: relative;
  padding: 0;
  margin: 0;
  background: linear-gradient(to right, #EAECC6, #2BC0E4);
}

.link {
  color: #707070;
  text-decoration: none;
}

.user-link {
  display: inline-block;
  overflow: hidden;
  background: #fff;
  border-radius: 100%;
  box-shadow: 0 1px 1px rgba(0, 0, 0, 0.3);
  text-decoration: none;
  margin-top: -43px;
  border: 3px solid #fff;
  position: relative;
}

.github-avatar {
  display: block;
  width: 5rem;
  height: 5rem;
}

.github-info {
  font-size: 12px;
  color: #707070;
  list-style-type: none;
  margin: 0;
  padding: 0;
  border-top: 1px solid #eee;
  zoom: 1;

  a {
    color: #707070;
  }

  strong {
    display: block;
    color: #292f33;
    font-size: 16px;
    line-height: 1.6;
  }

  li {
    width: 33.33%;
    float: left;
    font-size: 12px;
    padding: 8px 0;
    box-shadow: 1px 0 0 #eee;
  }
}
</style>