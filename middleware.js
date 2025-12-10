import { next } from "@vercel/edge";

// ページ以下はbasic認証
export const config = {
  matcher: ["/demo/:path*", "/playground/:path*"],
};

export default function middleware(request) {
  const authorizationHeader = request.headers.get("authorization");

  // 正解のユーザー/パスワード
  const validUser = process.env.BASIC_AUTH_USER;
  const validPass = process.env.BASIC_AUTH_PASSWORD;

  if (authorizationHeader) {
    const basicAuth = authorizationHeader.split(" ")[1];
    const [user, password] = atob(basicAuth).split(":");

    if (user === validUser && password === validPass) {
      return next();
    }
  }

  return new Response("Auth Required", {
    status: 401,
    headers: {
      "WWW-Authenticate": 'Basic realm="Secure Area"',
    },
  });
}
