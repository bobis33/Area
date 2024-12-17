export const useSnackbar = () => {
    const message = useState<string | null>('snackbarMessage', () => null)
    const type = useState<string>('snackbarType', () => 'success')

    const showSnackbar = (msg: string, snackbarType: string = 'success') => {
        message.value = msg
        type.value = snackbarType

        setTimeout(() => {
            message.value = null
        }, 3000)
    }
    return {
        message,
        type,
        showSnackbar,
    }
}
