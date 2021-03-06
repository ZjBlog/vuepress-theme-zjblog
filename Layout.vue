<template>
  <div>
    <div class="wrap" :style="flag? w2: w1">
      <div class="theme-container container"
        :class="pageClasses"
        @touchstart="onTouchStart"
        @touchend="onTouchEnd">
        <Navbar v-if="shouldShowNavbar" @toggle-sidebar="toggleSidebar"/>
        <div class="sidebar-mask" @click="toggleSidebar(false)"></div>
        <Sidebar :items="sidebarItems" @toggle-sidebar="toggleSidebar"/>
        <div class="page-container" :style="pageContainerClasses">
          <!-- custom layout -->
          <div class="custom-layout" v-if="$page.frontmatter.layout">
            <component :is="$page.frontmatter.layout"/>
          </div>
          <!-- Activity layout -->
          <Activity v-else-if="$page.frontmatter.activity"/>
          <!-- article list -->
          <ArticleGroup v-else-if="isRoot" :page-items="pageItems" />
          <!-- nav with layout list -->
          <ArticleGroup v-else-if="isNavLayout" :page-items="pageItems" />
          <!-- tags -->
          <Tags v-else-if="isTag" />
          <!-- article page -->
          <Page v-else :sidebar-items="sidebarItems"/>
          <!-- pagation selector -->
          <Pagation v-if="isRoot || isNavLayout" 
            :page-items="pages" 
            @change="page => currentPage = page" />
        </div>
        <ToolGroup v-if="!isNoToolGroup" />
      </div>
      <SWUpdatePopup :updateEvent="swUpdateEvent" />
    </div>
    <div class="background-mask" :style="flag?ff:wrapClasses"></div>
    <footer-blog></footer-blog>
  </div>
</template>

<script>
import Vue from "vue";
import nprogress from "nprogress";
import Activity from "./layout/Activity.vue";
import Navbar from "./components/Navbar.vue";
// import Page from "./Page.vue";
import Sidebar from "./components/Sidebar.vue";
import ToolGroup from "./components/ToolGroup.vue";
import ArticleGroup from './components/ArticleGroup.vue'
import LeetCodeGroup from './components/LeetCodeGroup.vue'
import Pagation from './components/Pagation.vue'
import SWUpdatePopup from './components/SWUpdatePopup.vue'
import Tags from './components/Tags.vue'
import navLayoutMixin from './lib/navLayout.mixin'
import { resolveSidebarItems, getTitle } from "./lib/util";
import FooterBlog from './components/footerblog'
const Page = () => import('./Page.vue')
export default {
  mixins: [navLayoutMixin],
  components: { 
    Activity, 
    Page, 
    Sidebar,
    Navbar, 
    ToolGroup, 
    ArticleGroup, 
    LeetCodeGroup, 
    Pagation,
    Tags,
    SWUpdatePopup,
    FooterBlog
  },
  data() {
    return {
      isSidebarOpen: false,
      currentPage: 1,
      swUpdateEvent: null,
      flag: false,
      w1: {
        minHeight: '750px'
      },
      w2: {
        minHeight: '750px',
        width: '100%',
        margin: '0 auto',
        padding: 0
      },
      ff:{
        background: 'url(/bd.jpg)'
      }
    };
  },
  watch: {
    '$route': {handler: 'change'}
  },
  computed: {
    isRoot() {
      return this.$route.meta.root || this.$route.path === this.$rootOptions.path;
    },
    isTag() {
      return this.$route.meta.tag;
    },
    isNoToolGroup() {
      return this.$page.frontmatter.layout || this.$page.frontmatter.activity
    },
    pageItems() {
      const start = (this.currentPage - 1) * this.perPage
      const end = this.currentPage * this.perPage
      return this.pages.filter((page, i) => (i >= start && i < end))
    },
    shouldShowNavbar() {
      const { themeConfig } = this.$site;
      return (
        this.$site.title ||
        themeConfig.logo ||
        themeConfig.repo ||
        themeConfig.nav
      );
    },
    shouldShowSidebar() {
      const { themeConfig } = this.$site;
      const { frontmatter } = this.$page;
      return (
        !frontmatter.layout &&
        !frontmatter.activity &&
        frontmatter.sidebar !== false &&
        this.sidebarItems.length
      );
    },
    sidebarItems() {
      return resolveSidebarItems(
        this.$page,
        this.$route,
        this.$site,
        this.$localePath
      );
    },
    // when Activity Component, dont show tool group and expand the page container's width to 100%
    pageContainerClasses() {
      return !this.isNoToolGroup ? {} : { width: '100%' }
    },
    pageClasses() {
      const userPageClass = this.$page.frontmatter.pageClass;
      return [
        {
          "no-navbar": !this.shouldShowNavbar,
          "sidebar-open": this.isSidebarOpen,
          "no-sidebar": !this.shouldShowSidebar,
        },
        userPageClass
      ];
    },
    wrapClasses() {
      const { themeConfig } = this.$site;
      let randomMath=Math.random()*(3000-1+1)+1;
      let imgMath=Math.floor(randomMath);
      let url = themeConfig.backgroundUrl? themeConfig.backgroundUrl:'https://img.infinitynewtab.com/wallpaper/' + imgMath + '.jpg';

      return themeConfig.background
        ? {
            background:
              'url("' +
              `${this.$withBase(themeConfig.background)}` +
              '")'
          }
        : { background: `url(${url})`,backgroundSize:'cover'};
    }
  },
  created() {
    if (this.$ssrContext) {
      this.$ssrContext.title = getTitle(this.$title, this.$page);
      this.$ssrContext.lang = this.$lang;
      this.$ssrContext.description =
        this.$page.description || this.$description;
    }
  },
  mounted() {
    let h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
    this.w1.minHeight= (h-100-70-26) +'px';
    this.w2.minHeight= (h-100-70-26) +'px';
    this.flag = this.$route.path === '/'
    // when swtich tab, change the current page
    const updateCurPage = () => {
      this.currentPage = 1
    }
    this.$watch('pages', updateCurPage)

    // configure progress bar
    nprogress.configure({ showSpinner: false });

    this.$router.beforeEach((to, from, next) => {
      if (to.path !== from.path && !Vue.component(to.name)) {
        nprogress.start();
      }
      next();
    });

    this.$router.afterEach(() => {
      nprogress.done();
      this.isSidebarOpen = false;
    });

    this.$on('sw-updated', this.onSWUpdated);
    this.baiduPush(window.location.href)
    // baiduPush(window.location.href)
    this.initCnzz()
  },
  methods: {
    initCnzz () {
      const { themeConfig } = this.$site;
      if (!!themeConfig.cnzzUrl) {
        console.info('init cnzz')
        const script = document.createElement('script')
        script.src = themeConfig.cnzzUrl
        script.language = 'JavaScript'
        document.body.appendChild(script)
      } else {
        console.info('no cnzz url')
      }
    },
    baiduPush (href) {
      const { themeConfig } = this.$site;
      if(!themeConfig.baidpush){
          console.info('close baidu')
          return;
      }
      if (href.substring(0,5) !== 'https') {
        console.info('dev')
        return;
      }
      console.info('baidpush:' + href)
      // console.info('=======pro========:' + href)
      !function(){
        let e = /([http|https]:\/\/[a-zA-Z0-9\_\.]+\.baidu\.com)/gi
        let r = href || window.location.href
        let t = document.referrer
        if (!e.test(r)) {
          let o = "https://sp0.baidu.com/9_Q4simg2RQJ8t7jm9iCKT-xh_/s.gif"
          t ? (o += "?r=" + encodeURIComponent(document.referrer), r && (o += "&l=" + r)) : r && (o += "?l=" + r)
          let i = new Image
          i.src = o
        }
      }(window)
    },
    change (to, from) {
      this.flag = window.location.pathname === '/'
      // baiduPush(window.location.href)
      this.baiduPush(window.location.href)
      if (window._czc) {
        console.info('push')
        let contentUrl = to.path
        let refererUrl = window.location.href
        window._czc.push(['_trackPageview', contentUrl, refererUrl])
      }
    },
    toggleSidebar(to) {
      this.isSidebarOpen = typeof to === "boolean" ? to : !this.isSidebarOpen;
    },
    // side swipe
    onTouchStart(e) {
      this.touchStart = {
        x: e.changedTouches[0].clientX,
        y: e.changedTouches[0].clientY
      };
    },
    onTouchEnd(e) {
      const dx = e.changedTouches[0].clientX - this.touchStart.x;
      const dy = e.changedTouches[0].clientY - this.touchStart.y;
      if (Math.abs(dx) > Math.abs(dy) && Math.abs(dx) > 40) {
        if (dx > 0 && this.touchStart.x <= 80) {
          this.toggleSidebar(true);
        } else {
          this.toggleSidebar(false);
        }
      }
    },
    onSWUpdated(e) {
      console.log('pwa update: ', e);
      this.swUpdateEvent = e;
    }
  }
};
</script>

<style src="prismjs/themes/prism-tomorrow.css"></style>
<style src="./styles/theme.styl" lang="stylus"></style>