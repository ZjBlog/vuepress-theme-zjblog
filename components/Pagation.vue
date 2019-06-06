<template>
  <nav :class="tagsShow?'pagation-nav1':'pagation-nav'">
    <span class="pagation-action pagation-prev" 
      @click="prevPage"
      v-if="currPage > 1">上一页</span>
    <template>
      <span v-for="(num, index) in pageSum1"
        :key="index" 
        class="pagation-num"
        @click="changeCurrentPage(num)"
        :class="hightlightCurrentPage(num)">
        {{ num }}
      </span>  
    </template> 
    <span class="pagation-action pagation-next" 
      @click="nextPage"
      v-if="currPage < allPage">下一页</span>
  </nav>
</template>

<script>
import navLayoutMixin from '../lib/navLayout.mixin'

export default {
  mixins: [navLayoutMixin],  
  props: {
    pageItems: {
      default: () => []
    }
  },
  data() {
    return {
      tagsShow: false,
      currentPage: 1,
      list:[],
      currPage: 1
    }
  },
  methods: {
    changeCurrentPage(pageNum) {
      window.scrollTo(0, 0);
      this.currentPage = pageNum
    },
    prevPage() {
      console.info(this.currPage)
      let page = this.currPage - 1
      this.currPage = this.currPage -1
      this.currentPage = (page-1) * 8 +1
    },
    nextPage() {
      let page = this.currPage
      this.currPage = this.currPage + 1
      this.currentPage = page * 8 +1
    },
    hightlightCurrentPage(pageNum) {
      return {
        'pagation-current': pageNum === this.currentPage
      }
    },
  },
  computed: {
    pageSum() {
      console.info(this.pageItems.length)
      console.info(this.perPage)
      return Math.ceil(this.pageItems.length / this.perPage)
    },
    pageSum1() {
      let all = Math.ceil(this.pageItems.length / this.perPage)
      if(all<=8){
        for(let i=1;i<=all;i++){
          this.list.push(i)
        }
      }else{
        let i = (this.currPage-1) * 8 +1
        let j = this.currPage * 8>=all?all:this.currPage*8
        this.list=[]
        for(i;i<=j;i++){
          this.list.push(i)
        }
      }
      return this.list;
    },
    allPage () {
      let all = Math.ceil(this.pageItems.length / this.perPage)
      return Math.ceil(all/8)
    }
  },
  watch: {
    currentPage(pageNum) {
      this.$emit('change', pageNum)
    }
  },
  mounted () {
    this.tagsShow = window.location.href.indexOf('tags')>0
  }
}
</script>

<style lang="stylus">
.pagation-nav
  border-radius 10px
  background #FFF
  margin-right 10px
  padding 1rem
  text-align center
  clear both
  line-height 2
  overflow hidden
  span:hover
    color #409EFF
.pagation-nav1
  border-radius 10px
  margin-right 10px
  padding 1rem
  text-align center
  clear both
  line-height 2
  overflow hidden
  span:hover
    color #409EFF
.pagation-action
  display block
  text-align center
  cursor pointer
  width 4rem
  height 2rem
  background-color #fff

.pagation-num
  font-size 18px
  color #000
  cursor pointer
  padding 10px 20px
  line-height 1
  height 2ex

.pagation-prev
  float left

.pagation-next
  float right

.pagation-current
  font-weight 700
  color #409EFF
  font-size 20px
</style>