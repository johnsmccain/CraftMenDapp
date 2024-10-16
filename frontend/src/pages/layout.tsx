import React, { Children } from "react";
import { Outfit } from "next/font/google";
import NextAuthSessionProvider from "./provider";
import { Toaster } from "@/components/ui/sonner";
import { Header } from "@/components/Header";
// import type { AppProps } from "next/app";
const inter = Outfit({ subsets: ["latin"] });

const RootLayout = ({ children }: any) => {
	return (
		<html lang="en">
			<body className={inter.className}>
				<NextAuthSessionProvider>
					<div className="mx-6 md:mx-16">
						<Header />
						<Toaster />
						{children}
					</div>
				</NextAuthSessionProvider>
			</body>
		</html>
	);
};

export default RootLayout;
