import { ref } from 'vue'
import { useCookie } from '#app'

import { verifyToken } from '~/domain/use-cases/VerifyToken'
import { CookiesEnum } from "~/constants";

export const useAuth = () => {
    const isAuthenticated = ref(false)

    const checkAuth = async () => {
        const token = useCookie(CookiesEnum.TOKEN.toString()).value
        if (token) {
            isAuthenticated.value = await verifyToken(token)
        }
    }
    return { isAuthenticated, checkAuth }
}
