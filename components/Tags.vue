<template>
    <div>
        <h2 :style="overrideStyle">TAGS</h2>
        <div class="tag-group">
            <Tag v-for="tag in Object.keys($tags)"
                :tag="$tags[tag]"
                :highlight="true"
                :slug="tag"
                :key="tag">
                #{{tag}} {{$tags[tag].length}}
            </Tag>
        </div>
        <ArticleGroup :page-items="pageItems" />
        <Pagation 
            :page-items="pageWithSpecTag"
            @change="page => currentPage = page" :key='key'/>
    </div>
</template>

<script>
import Tag from './Tag';
import ArticleGroup from './ArticleGroup.vue';
import Pagation from './Pagation.vue'
import navLayoutMixin from '../lib/navLayout.mixin'

export default {
    mixins: [navLayoutMixin],
    data() {
        return {
            currentPage: 1,
            key: '12'
        }
    },
    mounted() {
        const updateCurPage = () => {
            this.currentPage = 1
        }
        this.$watch('pageWithSpecTag', updateCurPage)
    },
    components: { Tag, ArticleGroup, Pagation },
    watch: {
        '$route' (to, from) {
            this.key = Date.now()
        }
    },
    computed: {
        overrideStyle() {
            const accentColor = this.$site.themeConfig['accentColor'];
            return accentColor ? { color: accentColor } : {}
        },
        tagName() {
            return this.$route.params.tagName;
        },
        pageItems() {
            const start = (this.currentPage - 1) * this.perPage;
            const end = this.currentPage * this.perPage;
            return this.pageWithSpecTag.filter((page, i) => (i >= start && i < end));
        },
        pageWithSpecTag() {
            if (!this.tagName) return [];
            const tagKeys = this.$tags[this.tagName];
            return this.pages.filter(page => page.key && !!~tagKeys.indexOf(page.key));
        },
    }
}
</script>
<style scoped>
.wrap {
 width:100%;
 margin:0 auto;
 padding: 0;
}
</style>

<style src="../styles/theme.styl" lang="stylus"></style>
<style lang="stylus">
.tag-group {
    margin-bottom 1rem
}
</style>
