import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'
import './style.css'
import App from './App.vue'
import HomePage from './components/HomePage.vue'
import EventDetail from './components/EventDetail.vue'

const routes = [
  { path: '/', component: HomePage },
  { path: '/event/:id', component: EventDetail, props: true }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

createApp(App).use(router).mount('#app')