import { createStore } from 'vuex'

export interface State {
  user: {
    id: string | null
    email: string | null
    name: string | null
  } | null
  theme: 'light' | 'dark'
}

export default createStore<State>({
  state: {
    user: null,
    theme: 'light'
  },
  mutations: {
    setUser(state, user) {
      state.user = user
    },
    clearUser(state) {
      state.user = null
    },
    toggleTheme(state) {
      state.theme = state.theme === 'light' ? 'dark' : 'light'
      document.documentElement.setAttribute('data-theme', state.theme)
    }
  },
  actions: {
    async login({ commit }, credentials) {
      // 这里可以调用 Supabase 登录 API
      console.log('登录', credentials)
    },
    async logout({ commit }) {
      commit('clearUser')
    }
  },
  getters: {
    isAuthenticated: (state) => !!state.user,
    currentUser: (state) => state.user,
    currentTheme: (state) => state.theme
  }
})
