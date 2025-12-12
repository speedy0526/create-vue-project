import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import ElementPlus from 'element-plus'
import { FontAwesomeIcon } from './plugins/fontawesome'
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'

// 导入样式
import 'element-plus/dist/index.css'
import 'element-plus/theme-chalk/dark/css-vars.css'

const app = createApp(App)

// 注册全局组件
app.component('FontAwesomeIcon', FontAwesomeIcon)

// 将 pinia 实例挂载到应用
const pinia = createPinia()
pinia.use(piniaPluginPersistedstate)
app.use(pinia)

// 使用插件
app.use(ElementPlus)
app.use(router)
app.use(store)

app.mount('#app')
