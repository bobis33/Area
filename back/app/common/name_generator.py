class NameGenerator:
    @staticmethod
    def generate_username_from_email(email):
        username: str = email.split("@")[0]
        username.replace(".", " ")
        return username.capitalize()
