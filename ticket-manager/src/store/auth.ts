import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { AuthUser } from '@/services/auth.service'
import { UserRole } from '@/services/auth.service'
import { authService } from '@/services/auth.service'

export const useAuthStore = defineStore('--ticket-system-auth', {
    state: () => {
        const user = ref<AuthUser | null>(null)
        const isLoading = ref(false)
        const error = ref<string | null>(null)

        const isAuthenticated = computed(() => !!user.value)
        const isSuperAdmin = computed(() => user.value?.role === UserRole.SUPER_ADMIN)
        const isTenantAdmin = computed(() => user.value?.role === UserRole.TENANT_ADMIN)
        const isAgent = computed(() => user.value?.role === UserRole.AGENT)
        const isCustomer = computed(() => user.value?.role === UserRole.CUSTOMER)
        const isViewer = computed(() => user.value?.role === UserRole.VIEWER)

        async function loadUser() {
            isLoading.value = true
            try {
                user.value = await authService.getCurrentUser()
                error.value = null
            } catch (err: any) {
                error.value = err.message
                user.value = null
            } finally {
                isLoading.value = false
            }
        }

        async function signIn(email: string, password: string) {
            isLoading.value = true
            try {
                await authService.signIn(email, password)
                await loadUser()
                error.value = null
            } catch (err: any) {
                error.value = err.message
                throw err
            } finally {
                isLoading.value = false
            }
        }

        async function signOut() {
            isLoading.value = true
            try {
                await authService.signOut()
                user.value = null
                error.value = null
            } catch (err: any) {
                error.value = err.message
                throw err
            } finally {
                isLoading.value = false
            }
        }

        // 初始化时加载用户
        loadUser()

        // 监听认证状态变化
        authService.onAuthStateChange(async (event) => {
            if (event === 'SIGNED_OUT') {
                user.value = null
            } else if (event === 'SIGNED_IN' || event === 'USER_UPDATED') {
                await loadUser()
            }
        })

        return {
            user,
            isLoading,
            error,
            isAuthenticated,
            isSuperAdmin,
            isTenantAdmin,
            isAgent,
            isCustomer,
            isViewer,
            signIn,
            signOut,
            loadUser,
        }
    },
    persist: true
})
